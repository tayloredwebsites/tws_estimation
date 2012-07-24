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
    @estimate_assemblies = Hash.new()
    estimate_assemblies.each do |est_ass|
      # set true if this estimate has this estimate_assembly saved already
      @estimate_assemblies[est_ass.assembly_id] = true if est_ass.selected
    end
    component_types = ComponentType.order(:sort_order)
    # Rails.logger.debug("* EstimatesController.before_filter component_types = #{component_types.inspect.to_s}")
    @component_types = Hash.new()
    component_types.each do |comp_type|
      @component_types[comp_type.id] = comp_type
      Rails.logger.debug("* EstimatesController.before_filter @component_types[#{comp_type.id}] = #{comp_type.description}")
    end
    # @assembly_ids = Array.new()
    # @assemblies.each do |ass|
    #   @assembly_ids << ass.id
    # end
  end
  
  def self.list(scope = nil)
    list_scope = (scope.nil?) ? self.new.get_scope() : scope
  end

  # chain current scope with any modules that have set scope (e.g. DeactivatedController)
  def get_scope(cur_scope = nil)
    # base default scope is set up here so that deactivated module can update this
    cur_scope = Estimate.scoped if (cur_scope.nil?)
    return (defined?(super)) ? super(cur_scope) : cur_scope
  end

  # GET /estimates/menu
  def menu
  end

  # GET /estimates
  def index
    @estimates = get_scope().joins(:sales_rep).joins('JOIN users ON sales_reps.user_id = users.id').order('users.last_name, users.first_name, title')
  end

  # GET /estimates/list
  def list
    # @estimates = get_scope().joins(:sales_rep).order('title')
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
    # all this code is done in controller because params passing problems
    ActiveRecord::Base.transaction do
      begin
        Rails.logger.debug("* EstimatesController.create - params = #{params.inspect.to_s}")
        @estimate = Estimate.new(params[:estimate])
        authorize! :create, @estimate   # authorize from CanCan::ControllerAdditions
        if !@estimate.errors.empty?
          # will this code ever be touched?
          @estimate.errors.each do |attr, msg|
            Rails.logger.error("E EstimatesController.create - Estimate.new - got error = #{attr} - #{msg}")
          end
          raise ActiveRecord::Rollback, "Estimate Create error on new()"
        else
          if !params[:estimate_assemblies].nil?
            params[:estimate_assemblies].each do |ec_key, ec_value|
              if !ec_value.blank?
                c_attribs = {:estimate_id=>nil, :assembly_id=> ec_key, :selected => true}
                Rails.logger.debug("***** EstimatesController.create estimate_assemblies c_attribs = #{c_attribs.inspect.to_s}")
                @estimate.estimate_assemblies.build(c_attribs)
              end
            end
          end
          if !params[:estimate_components].nil?
            params[:estimate_components].each do |ec_key, ec_value|
              if !ec_value.blank?
                c_attribs = EstimateComponent.params_from_key_string(ec_key).merge(:value => ec_value)
                Rails.logger.debug("***** EstimatesController.create estimate_components c_attribs = #{c_attribs.inspect.to_s}")
                @estimate.estimate_components.build(c_attribs)
              end
            end
          end
          Rails.logger.debug("***** EstimatesController.create - save")
          @estimate.save
          Rails.logger.debug("***** EstimatesController.create - save completed")
        end
      rescue ActiveRecord::ActiveRecordError => ex
        # capture the exceptions
        Rails.logger.error("E EstimateController.create - Active Record Error ex - #{ex.to_s}")
        Rails.logger.error("E EstimateController.create - Active Record Error $!- #{$!.to_s}")
        notify_error( I18n.translate('errors.error_msg',
          :msg => ex.to_s )
        )
      else
        if @estimate.errors.empty?
          Rails.logger.debug("***** EstimatesController.create - no errors")
          notify_success( I18n.translate('errors.success_method_obj_name',
            :method => params[:action],
            :obj => 'Estimate',
            :name => @estimate.desc )
          )
          # using redirect because render is not showing updated associations.
          redirect_to @estimate, notice: 'Estimate was successfully created.'
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
    ActiveRecord::Base.transaction do
      begin
        Rails.logger.debug("* EstimatesController.create - params = #{params.inspect.to_s}")
        @estimate = get_scope().find(params[:id])
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
                Rails.logger.debug("* Estimate.update - estimate_assemblies was:#{was_id},#{was_value}, is_now[was_id]:#{is_now[was_id]}")
                if was_value == 'false'
                  # if is now, change
                  if !is_now[was_id].nil?
                    Rails.logger.debug("* Estimate.update_estimate_assemblies - change estimate_assembly ( estimate_id:#{@estimate.id},assembly_id:#{was_id} ) to true:#{is_now[was_id]}")
                    ea = EstimateAssembly.where(:estimate_id => @estimate.id, :assembly_id => was_id).first
                    if ea.nil?
                      ea = EstimateAssembly.new(:estimate_id => @estimate.id, :assembly_id => was_id)
                    end
                    Rails.logger.debug("* Estimate.update_estimate_assemblies - create estimate_assembly = #{ea.inspect.to_s}")
                    ea.selected = true
                    ea.save!
                  end # !is_now[was_id].nil?
                else #  was_value == 'false'
                  # if isn't now, change
                  if is_now[was_id].nil?
                    Rails.logger.debug("* Estimate.update_estimate_assemblies - change estimate_assembly ( estimate_id:#{@estimate.id},assembly_id:#{was_id} ) to false:#{is_now[was_id]}")
                    Rails.logger.debug("* Estimate.update_estimate_assemblies - change to false:#{is_now[was_id]}")
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
              Rails.logger.debug("* Estimate.update - estimate_components was_before:#{was_before.inspect.to_s}, is_now:#{is_now.inspect.to_s}")
              is_now.each do |is_id, is_value|
                Rails.logger.debug("* Estimate.update - estimate_component - was_before[is_id]:#{was_before[is_id]} ==? is_value:#{is_value}")
                if was_before[is_id] != is_value
                  Rails.logger.debug("* Estimate.update - estimate_component - update estimate_component ( estimate_component_id:#{is_id} ) to #{is_value}")
                  est_comp_ids = is_id.split("_") # 
                  if est_comp_ids.size != 4
                    Rails.logger.error("E Estimate.update_estimate_component_attributes - invalid ids size")
                    @estimate.errors.add("invalid size of ids - #{est_comp_ids}")
                  else
                    # [#{@estimate.id}_#{ass.id}_#{component.id}_#{est_comp.id.to_s}]
                    est_comp = (est_comp_ids[3] == '0') ? nil : EstimateComponent.find(est_comp_ids[3])
                    if !est_comp
                      # create new estimate component
                      est_comp = EstimateComponent.new()
                    end
                    # est_comp.estimate_id = est_comp_ids[0]
                    est_comp.estimate_id = @estimate.id
                    est_comp.assembly_id = est_comp_ids[1]
                    est_comp.component_id = est_comp_ids[2]
                    est_comp.value = BigDecimal(is_value)
                    est_comp.save!
                  end #  est_comp_ids.size != 4
                else #  was_before[is_id] != is_value
                  Rails.logger.debug("* Estimate.update_estimate_component_attributes - no change ( estimate_component_id:#{is_id} ) == #{is_value}")
                end #  was_before[is_id] != is_value
              end # is_now.each do
            end
          end # !@estimate.errors.empty?
        else
          raise ActiveRecord::Rollback, "Attempt to #{params[:action]} #{@model.class.name}.id:#{params[:id]} when not in scope"
        end
      rescue ActiveRecord::ActiveRecordError => ex
        # capture the exceptions
        Rails.logger.error("E EstimateController.update - Active Record Error ex - #{ex.to_s}")
        Rails.logger.error("E EstimateController.update - Active Record Error $!- #{$!.to_s}")
        notify_error( I18n.translate('errors.error_msg',
          :msg => ex.to_s )
        )
      else
        if @estimate.errors.empty?
          success_msg = I18n.translate('errors.success_method_obj_name',
            :method => params[:action],
            :obj => 'Estimate',
            :name => @estimate.desc
          )
          notify_success( success_msg )
          # using redirect because render is not showing updated associations.
          redirect_to @estimate, notice: success_msg
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
