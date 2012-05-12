class AssembliesController < SecureApplicationController

  # allow records to be deactivated using extras/controllers/deactivated_controller.rb
  include Controllers::DeactivatedController
  
  def initialize
    # this is within the estimation maintenance sub-application
    @systemc = 'estimmaint'
    Rails.logger.debug("* AssembliesController.initialize - @systemc:#{@systemc}")
    super
  end

  before_filter do |controller|
    self.authenticate_user # always authenticate user   if (%w{ index show }.index(params[:action]).nil?)
    # create a components list for any renders that require the component listing
    if (!params[:id].nil?)
      # set up here because these are used for rendering from deactivated module
      @assembly_components = AssemblyComponentsController.new.get_scope().joins(:assembly).joins(:component).where(:assembly_id => params[:id] ).order('components.description, assembly_components.description')
    else
      # make sure that we have at least an empty components list
      @assembly_components = []
    end
  end
  
  def self.list(scope = nil)
    list_scope = (scope.nil?) ? self.new.get_scope() : scope
  end

  # chain current scope with any modules that have set scope (e.g. DeactivatedController)
  def get_scope(cur_scope = nil)
    # base default scope is set up here so that deactivated module can update this
    cur_scope = Assembly.scoped if (cur_scope.nil?)
    return (defined?(super)) ? super(cur_scope) : cur_scope
  end

  # GET /assemblies/menu
  def menu
  end

  # GET /assemblies
  def index
    @assemblies = get_scope().order('sort_order')
  end

  # GET /assemblies/list
  def list
    @assemblies = get_scope().order('description')
  end

  # GET /assemblies/:id
  def show
    @assembly = get_scope().find(params[:id])
  end

  # GET /assemblies/new
  def new
    Rails.logger.debug("* AssembliesController.new - params = #{params.inspect.to_s}")
    @assembly = Assembly.new
  end

  # GET /assemblies/:id/edit
  def edit
    Rails.logger.debug("* AssembliesController.edit - params = #{params.inspect.to_s}")
    Rails.logger.debug("* AssembliesController.edit - @components = #{@components.inspect.to_s}")
    @assembly = get_scope().find(params[:id])
  end

  # POST /assemblies
  def create
    Rails.logger.debug("* AssembliesController.create - params = #{params.inspect.to_s}")
    @assembly = Assembly.new(params[:assembly])
    if @assembly.save
      # redirect_to @assembly, notice: 'Assembly was successfully created.'
      render :action => 'show'
    else
      render :action => "new"
    end
  end

  # PUT /assemblies/:id
  def update
    # updates are passed to the deactivated controller, as it knows how to handle deactivated records
    super # call to parent (e.g. Controllers::DeactivatedController)
  end

  # DELETE /assemblies/:id
  def destroy
    # destroys are passed to the deactivated controller, as it knows how to handle deactivated records
    super # call to parent (e.g. Controllers::DeactivatedController)
  end
end
