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
    if (!params[:id].nil?)
      # @estimate_assemblies = Assembly.includes(:estimate_assemblies) #.where('estimate_assemblies.estimate_id = ? and (assemblies.deactivated IS NOT TRUE OR estimate_assemblies.selected IS TRUE)', params[:estimate_id])
      @estimate_assemblies = EstimateAssembly.joins('RIGHT JOIN assemblies ON estimate_assemblies.assembly_id = assemblies.id')#.where('estimate_assemblies.estimate_id = ?', params[:estimate_id]) # and (assemblies.deactivated IS NOT TRUE OR estimate_assemblies.selected IS TRUE)
    else
      # make sure that we have at least the list of Assemblies
      @estimate_assemblies = Assembly.where('assemblies.deactivated IS NOT TRUE')
    end
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
    @estimates = get_scope().order('title')
  end

  # GET /estimates/list
  def list
    @estimates = get_scope().joins(:sales_rep).joins('JOIN users ON sales_reps.user_id = users.id').order('users.last_name, users.first_name, title')
    # @estimates = get_scope().joins(:sales_rep).order('title')
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
    Rails.logger.debug("* EstimatesController.create - params = #{params.inspect.to_s}")
    @estimate = Estimate.new(params[:estimate])
    if @estimate.save
      # redirect_to @estimate, notice: 'Estimate was successfully created.'
      render :action => 'show'
    else
      render :action => "new"
    end
  end

  # PUT /estimates/:id
  def update
    # updates are passed to the deactivated controller, as it knows how to handle deactivated records
    super # call to parent (e.g. Controllers::DeactivatedController)
  end

  # DELETE /estimates/:id
  def destroy
    # destroys are passed to the deactivated controller, as it knows how to handle deactivated records
    super # call to parent (e.g. Controllers::DeactivatedController)
  end
  
end
