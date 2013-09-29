class EstimatesController < SecureApplicationController

  # allow records to be deactivated using extras/controllers/deactivated_controller.rb
  include Controllers::DeactivatedController

  def initialize
    # this is within the estimation maintenance sub-application
    @systemc = 'estimmaint'
    Rails.logger.debug("* EstimateController.initialize - @systemc:#{@systemc}")
    super
  end

  before_filter do |controller|
    self.authenticate_user # always authenticate user   if (%w{ index show }.index(params[:action]).nil?)
    Rails.logger.debug("* EstimatesController.before_filter called with id: #{params[:id]}")
    # list of all Assemblies, with current selected EstimateAssemblies selected
    # note: if an Assembly is deactivated, it will only be listed if it is selected in EstimateAssemblies
    est_id = (params[:id].nil? ? '0' : params[:id])
    @assemblies = Assembly.order(:sort_order)
    estimate_assemblies = EstimateAssembly.where('estimate_id = ?', est_id)
    @estimate_components = EstimateComponent.joins(:component => :component_type).where('estimate_components.estimate_id = ?', est_id ).order('component_types.sort_order, components.description')
    estimate_has_component_types = Hash.new()
    @estimate_components.each do |ec|
      if !ec.component.nil? && !ec.component.component_type.nil?
        estimate_has_component_types[ec.component.component_type.id] = ec
      end
    end
    @estimate_assemblies = Hash.new()   # Assemblies for an Estimate that have been selected/checked
    estimate_assemblies.each do |est_ass|
      # set true if this estimate has this estimate_assembly saved already
      @estimate_assemblies[est_ass.assembly_id] = true if est_ass.selected
    end
    component_types = ComponentType.order(:sort_order)
    # Rails.logger.debug("* EstimatesController.before_filter component_types = #{component_types.inspect.to_s}")
    @component_types_list = Array.new()
    @component_types = Hash.new()
    component_types.each do |comp_type|
      if estimate_has_component_types[comp_type.id] || !comp_type.deactivated
        @component_types_list << comp_type
      end
      @component_types[comp_type.id] = comp_type
      Rails.logger.debug("* EstimatesController.before_filter @component_types[#{comp_type.id}] = #{comp_type.description}")
    end
  end

  def self.list(scope = nil)
    list_scope = (scope.nil?) ? self.new.get_scope() : scope
  end

  # chain current scope with any modules that have set scope (e.g. DeactivatedController, cancan auth)
  def get_scope(cur_scope = nil)
    # base default scope is set up here so that deactivated module can update this
    cur_scope = Estimate.scoped.accessible_by(current_ability) if cur_scope.nil?
    return (defined?(super)) ? super(cur_scope) : cur_scope
  end

  # GET /estimates/menu
  def menu
  end

  # GET /estimates
  def index
    Rails.logger.debug("****** EstimatesController.index current_user = #{current_user.inspect.to_s}")
    @estimates = get_scope.accessible_by(current_ability)
  end

  # GET /estimates/list
  def list
    Rails.logger.debug("* EstimatesController.list current_user = #{current_user.inspect.to_s}")
    @estimates = get_scope().order('title')
  end

  # GET /estimates/:id
  def show
    @estimate = get_scope().find(params[:id])
  end

  # GET /estimates/new
  def new
    Rails.logger.debug("* EstimatesController.new - params = #{params.inspect.to_s}")
    # only pass attribute parameters to new method (to pre-initialize params such as parent association id)
    # todo - limit params to accessible attributes!
    attribute_params = params.dup
    attribute_params.delete_if{|key, val| Estimate.new.attribute_names.index(key).nil? }
    @estimate = Estimate.new(attribute_params)
  end

  # GET /estimates/:id/edit
  def edit
    @estimate = get_scope().find(params[:id])
  end

  # POST /estimates
  def create
    # all this code is done in controller because records are created based upon custom parameters, and only if necessary
    ActiveRecord::Base.transaction do
      begin
        Rails.logger.debug("* EstimatesController.create - params = #{params.inspect.to_s}")
        # Rails.logger.debug("* EstimatesController.create - new")
        @estimate = Estimate.new(params[:estimate])
        authorize! :create, @estimate   # authorize from CanCan::ControllerAdditions
        @estimate = Estimate.create(params[:estimate])
        @estimate.save
        # capture the exceptions
        Rails.logger.error("E EstimateController.create - Active Record Error ex = $! - #{ex.to_s}")
        notify_error( I18n.translate('errors.error_msg',
          :msg => ex.to_s )
        )
        render :action => "new"
      else
        if @estimate.errors.empty?
          Rails.logger.debug("***** EstimatesController.create - no errors")
          notify_success( I18n.translate('errors.success_method_obj_name',
            :method => params[:action],
            :obj => 'Estimate',
            :name => @estimate.desc )
          )
          # using redirect because render is not showing created associations.
          redirect_to edit_estimate_path(@estimate.id), notice: 'Estimate was successfully created.'
          # render :action => 'show' # does not refresh all instance variables
        else
          Rails.logger.debug("***** EstimatesController.create - errors")
          notify_error( I18n.translate('errors.error_msg',
            :msg => @estimate.errors.full_messages )
          )
          render :action => "new"
        end
      # ensure
      end
    end
  end

  # PUT /estimates/:id
  def update
    # all this code is done here in controller to match create processing
    # updates are NOT passed to Controllers::DeactivatedController (via super) to handle the associations processing
    # this code is designed to collect the enormous amount of entry fields on the page, with custom naming and special coding to only insert necessary fields)
    # Intend to simplify this using fatter models and by splitting out the estimate component, estimate assembly and estimate updates that all take place from this update.
    ActiveRecord::Base.transaction do
      begin
        warn_if_missing_required_fields = false
        # Rails.logger.debug("* EstimatesController.update - params = #{params.inspect.to_s}")
        @estimate = get_scope().find(params[:id])
        # get non-read only version of estimate, so that it can be updated (read-only from accessible_by(current_ability) in get_scope() )
        @estimate = can?(:edit, @estimate) ? Estimate.find(params[:id]) : Estimate.new()
        if (!@estimate.nil?)
          authorize! :update, @estimate   # authorize from CanCan::ControllerAdditions
          @estimate.update_attributes(params[:estimate])  # .dup) why?
          if !@estimate.errors.empty?
            @estimate.errors.each do |attr, msg|
              Rails.logger.error("E EstimatesController.update - Estimate.update_attributes - got error = #{attr} - #{msg}")
            end
            raise ActiveRecord::Rollback, "Estimate update error on update_attributes()"
          else
            if !params[:estimate_assemblies].nil? && !params[:estimate_assemblies_was].nil?
              is_now = params[:estimate_assemblies]
              params[:estimate_assemblies_was].each do |was_id, was_value|
                # Rails.logger.debug("* Estimate.update - estimate_assemblies was:#{was_id},#{was_value}, is_now[was_id]:#{is_now[was_id]}")
                if was_value == 'false'
                  # if is now, change
                  if !is_now[was_id].nil?
                    ea = EstimateAssembly.where(:estimate_id => @estimate.id, :assembly_id => was_id).first
                    if ea.nil?
                      ea = EstimateAssembly.new(:estimate_id => @estimate.id, :assembly_id => was_id)
                    end
                    ea.selected = true
                    ea.save!
                  end # !is_now[was_id].nil?
                else #  was_value == 'false'
                  # if isn't now, change
                  if is_now[was_id].nil?
                    ea = EstimateAssembly.where(:estimate_id => @estimate.id, :assembly_id => was_id).first
                    ea.selected = false
                    ea.save!
                  end #  is_now[was_id].nil?
                end #  was_value == 'false'
              end # params[:estimate_assemblies_was].each
            end #  !params[:estimate_assemblies].nil? && !params[:estimate_assemblies_was].nil?
            if !params[:estimate_components].nil? && !params[:estimate_components_was].nil?
              # loop through all current component values, and compare to old values (to see if changed or added)
              was_before = params[:estimate_components_was]
              is_now = params[:estimate_components]
              was_before_note = params[:estimate_components_note_was]
              is_now_note = params[:estimate_components_note]
              was_before_tax = params[:estimate_components_tax_pct_was].nil? ? Hash.new() : params[:estimate_components_tax_pct_was]
              is_now_tax = params[:estimate_components_tax_pct].nil? ? Hash.new() : params[:estimate_components_tax_pct]

              # loop through all parameters returned from form
              is_now.each do |is_id, is_value|
                # handle null notes from grid components
                is_note = (is_now_note.nil? ? '' : (is_now_note[is_id].nil? ? '' : is_now_note[is_id]))
                was_note = (was_before_note.nil? ? '' : was_before_note[is_id])

                # pull out update parameters
                est_comp_ids = is_id.split("_") #
                if est_comp_ids.size != 2
                  @estimate.errors.add("invalid size of ids - #{est_comp_ids}")
                end

                # get the corresponding assembly component (has required flag)
                assy_comp = AssemblyComponent.where(:assembly_id => est_comp_ids[0], :component_id => est_comp_ids[1]).first

                # update if record changed
                is_changed = was_before[is_id] != is_value # || (was_before[is_id] == '' && is_value != '0.00' && is_value != '0.000' && is_value != '')
                is_changed ||= was_note != is_note
                is_changed ||= was_before_tax[is_id] != is_now_tax[is_id]
                is_new_empty_record = was_before[is_id] == 'nil' && (is_value == '0.00' || is_value == '0.000' || is_value == '') && is_note == '' && (is_now_tax[is_id] == '0.00' || is_now_tax[is_id] == '')
                do_update = (is_changed && !is_new_empty_record) || assy_comp.required # dont add record if empty, must add if required
                if do_update
                  # Rails.logger.debug("* Estimate.update - try to find - @estimate.id:#{@estimate.id}, is_id:#{is_id}")
                  tax_pct_in = is_now_tax[is_id].nil? ? BIG_DECIMAL_ZERO : BigDecimal(is_now_tax[is_id])
                  est_comp = EstimateComponent.for_estimate_assembly_component(@estimate.id, est_comp_ids[0].to_i, est_comp_ids[1].to_i )
                  if !est_comp
                    # Rails.logger.debug("*WARNUSER_MISSING* Estimate.update - NEW Estimate Component")
                    # create new estimate component
                    est_comp = EstimateComponent.new()
                    est_comp.estimate_id = @estimate.id
                    est_comp.assembly_id = est_comp_ids[0]
                    est_comp.component_id = est_comp_ids[1]
                    est_comp.value = BigDecimal(is_value,2)
                    # est_comp.calculate_labor_fields(est_comp.component)
                    est_comp.tax_percent = tax_pct_in
                    Rails.logger.debug("TAX PERCENT UPDATE Estimate.update -  est_comp.tax_percent:#{est_comp.tax_percent.bd_to_s(3)}")
                    est_comp.calculate_fields(self, est_comp.component)
                    est_comp.note = is_note
                    est_comp.save
                  else
                    est_comp.value = BigDecimal(is_value)
                    est_comp.tax_percent = tax_pct_in
                    est_comp.calculate_fields(self, est_comp.component)
                    est_comp.note = is_note
                    est_comp.save
                  end
                  # check for missing required fields
                  if !assy_comp.nil? && assy_comp.required && !est_comp.has_value?
                    warn_if_missing_required_fields = true
                  end
                end #  was_before[is_id] != is_value
              end # is_now.each do
            end
          end # !@estimate.errors.empty?
        else
          raise ActiveRecord::Rollback, "Attempt to #{params[:action]} #{@model.class.name}.id:#{params[:id]} when not in scope"
        end
      rescue ActiveRecord::ActiveRecordError => ex
        # capture the exceptions
        Rails.logger.error("E EstimateController.update - Active Record Error ex - #{ex.inspect.to_s}")
        Rails.logger.error("E EstimateController.update - Active Record Error $!- #{$!.to_s}")
        notify_error( I18n.translate('errors.error_msg',
          :msg => ex.to_s )
        )
        render :action => "edit"
      else # begin rescue ActiveRecordError else
        if @estimate.errors.empty?
          if !warn_if_missing_required_fields
            notify_msg = I18n.translate('errors.success_method_obj_name',
              :method => params[:action],
              :obj => 'Estimate',
              :name => @estimate.desc
            )
            notify_success( notify_msg )
          else
            notify_msg = I18n.translate('errors.warn_method_obj_name_warn',
              :method => params[:action],
              :obj => 'Estimate',
              :name => @estimate.desc,
              :warn => I18n.translate('error_messages.missing_required_field')
            )
            notify_warning( notify_msg )
          end
          # using redirect because render is not showing updated associations.
          redirect_to @estimate, notice: notify_msg
          # render :action => 'show' # does not refresh all instance variables
        else
          notify_error( I18n.translate('errors.error_msg',
            :msg => @estimate.errors.to_s )
          )
          render :action => "edit"
        end
      # ensure
      end

    end # ActiveRecord::Base.transaction do
  end

  # DELETE /estimates/:id
  def destroy
    # destroys are passed to the deactivated controller, as it knows how to handle deactivated records
    super # call to parent (e.g. Controllers::DeactivatedController)
  end

end
