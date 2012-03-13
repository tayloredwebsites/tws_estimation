class ComponentTypesController < SecureApplicationController

  # allow records to be deactivated using extras/controllers/deactivated_controller.rb
  include Controllers::DeactivatedController
  
  def initialize
    # this is within the maintenance sub-application
    @systemc = 'maint'
    Rails.logger.debug("* ComponentTypesController.initialize - @systemc:#{@systemc}")
    super
  end

  before_filter do |controller|
    # no actions require authentication (so far)
    self.authenticate_user # always authenticate user   if (%w{ index show }.index(params[:action]).nil?)
    # @model = ComponentType.new
  end

  # chain current scope with any modules that have set scope (e.g. DeactivatedController)
  def get_scope(cur_scope = nil)
    # Rails.logger.debug ("* ComponentTypesController.get_scope - cur_scope in: #{cur_scope.inspect.to_s}, show_deactivated?: #{show_deactivated?}")
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
      render :action => "edit"
    end
  end

  # PUT /component_types/:id
  def update
    super # call to parent (e.g. Controllers::DeactivatedController)
  end

  # DELETE /component_types/:id
  def destroy
    super # call to parent (e.g. Controllers::DeactivatedController)
  end
end
