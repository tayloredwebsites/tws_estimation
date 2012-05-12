class AssemblyComponentsController < SecureApplicationController

  # allow records to be deactivated using extras/controllers/deactivated_controller.rb
  include Controllers::DeactivatedController
  
  def initialize
    # this is within the estimation maintenance sub-application
    @systemc = 'estimmaint'
    Rails.logger.debug("* AssemblyComponentsController.initialize - @systemc:#{@systemc}")
    super
  end

  before_filter do |controller|
    self.authenticate_user # always authenticate user   if (%w{ index show }.index(params[:action]).nil?)
    # # create a components list for any renders that require the component listing
    # if (!params[:id].nil?)
    #   # set up here because these are used for rendering from deactivated module
    #   @components = ComponentsController.new.get_scope().where(:component_id => params[:component_id] ).order('description ASC')
    # else
    #   # make sure that we have at least an empty components list
    #   @components = []
    # end
  end
  
  def self.list(scope = nil)
    list_scope = (scope.nil?) ? self.new.get_scope() : scope
  end

  # chain current scope with any modules that have set scope (e.g. DeactivatedController)
  def get_scope(cur_scope = nil)
    # base default scope is set up here so that deactivated module can update this
    cur_scope = AssemblyComponent.scoped if (cur_scope.nil?)
    return (defined?(super)) ? super(cur_scope) : cur_scope
  end

  # GET /assembly_components/menu
  def menu
  end

  # GET /components
  def index
    @assembly_components = get_scope().joins(:assembly).joins(:component).order('assemblies.sort_order, components.description, assembly_components.description')
    # Rails.logger.debug("* AssemblyComponentsController @assembly_components 3 = #{@assembly_components.inspect.to_s}")
  end

  # GET /assembly_components/list
  def list
    @assembly_components = get_scope().joins(:component).order('components.description, assembly_components.description')
  end

  # GET /assembly_components/:id
  def show
    @assembly_component = get_scope().find(params[:id])
  end

  # GET /assembly_components/new
  def new
    # only pass attribute parameters to new method (to pre-initialize params such as parent association id)
    # todo - limit params to accessible attributes!
    # Rails.logger.debug("* AssemblyComponentsController.new - params = #{params.inspect.to_s}")
    attribute_params = params.dup
    attribute_params.delete_if{|key, val| AssemblyComponent.new.attribute_names.index(key).nil? }
    # Rails.logger.debug("* AssemblyComponentsController.new - attribute_params: #{attribute_params.inspect.to_s}")
    @assembly_component = AssemblyComponent.new(attribute_params)
  end
  
  # GET /assembly_components/:id/edit
  def edit
    @assembly_component = get_scope().find(params[:id])
  end

  # POST /components
  def create
    Rails.logger.debug("* AssemblyComponentsController.create - params = #{params.inspect.to_s}")
    @assembly_component = AssemblyComponent.new(params[:assembly_component])
    if @assembly_component.save
      # redirect_to @assembly_component, notice: 'Component was successfully created.'
      render :action => 'show'
    else
      render :action => "new"
    end
  end

  # PUT /assembly_components/:id
  def update
    # updates are passed to the deactivated controller, as it knows how to handle deactivated records
    super # call to parent (e.g. Controllers::DeactivatedController)
  end

  # DELETE /assembly_components/:id
  def destroy
    # destroys are passed to the deactivated controller, as it knows how to handle deactivated records
    super # call to parent (e.g. Controllers::DeactivatedController)
  end
end
