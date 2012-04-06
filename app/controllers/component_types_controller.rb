class ComponentTypesController < SecureApplicationController

  # allow records to be deactivated using extras/controllers/deactivated_controller.rb
  include Controllers::DeactivatedController
  
  def initialize
    # this is within the estimation maintenance sub-application
    @systemc = 'estimmaint'
    Rails.logger.debug("* ComponentTypesController.initialize - @systemc:#{@systemc}")
    super
  end

  before_filter do |controller|
    self.authenticate_user # always authenticate user   if (%w{ index show }.index(params[:action]).nil?)
    Rails.logger.debug("* ComponentTypesController.before_filter called with id: #{params[:id]}")
    # create a components list for any renders that require the component listing
    if (!params[:id].nil?)
      # set up here because these are used for rendering from deactivated module
      @components = ComponentsController.new.get_scope().where(:component_type_id => params[:id] ).order('description ASC')
    else
      # make sure that we have at least an empty components list
      @components = []
    end
  end

  def self.list(scope = nil)
    list_scope = (scope.nil?) ? self.new.get_scope() : scope
  end

  # chain current scope with any modules that have set scope (e.g. DeactivatedController)
  def get_scope(cur_scope = nil)
    # base default scope is set up here so that deactivated module can update this
    cur_scope = ComponentType.scoped if (cur_scope.nil?)
    return (defined?(super)) ? super(cur_scope) : cur_scope
  end

  # GET /component_types
  def index
    @component_types = get_scope().order('description ASC')
  end

  # GET /component_types/:id
  def show
    @component_type = get_scope().find(params[:id])
  end

  # GET /component_types/new
  def new
    @component_type = ComponentType.new
  end
  
  def new_component
    @component_type = get_scope().find(params[:id])
    @component = @component_type.components.build :component_type_id => params[:id]
    # render the component for this component type in the components resource
    render 'components/new'
  end

  # GET /component_types/:id/edit
  def edit
    @component_type = get_scope().find(params[:id])
  end

  # POST /component_types
  def create
    @component_type = ComponentType.new(params[:component_type])
    if @component_type.save
      # redirect_to @component_type, notice: 'Component type was successfully created.'
      render :action => 'show'
    else
      render :action => "new"
    end
  end

  # PUT /component_types/:id
  def update
    # updates are passed to the deactivated controller, as it knows how to handle deactivated records
    super # call to parent (e.g. Controllers::DeactivatedController)
  end

  # DELETE /component_types/:id
  def destroy
    # destroys are passed to the deactivated controller, as it knows how to handle deactivated records
    super # call to parent (e.g. Controllers::DeactivatedController)
  end
end
