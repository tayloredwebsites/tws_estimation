class DefaultsController < SecureApplicationController

  # allow records to be deactivated using extras/controllers/deactivated_controller.rb
  include Controllers::DeactivatedController
  
  def initialize
    # this is within the estimation maintenance sub-application
    @systemc = 'estimmaint'
    Rails.logger.debug("* DefaultsController.initialize - @systemc:#{@systemc}")
    super
  end

  before_filter do |controller|
    self.authenticate_user # always authenticate user   if (%w{ index show }.index(params[:action]).nil?)
    # @model = ComponentType.new
  end

  def self.list(scope = nil)
    list_scope = (scope.nil?) ? self.new.get_scope() : scope
  end

  # chain current scope with any modules that have set scope (e.g. DeactivatedController)
  def get_scope(cur_scope = nil)
    # Rails.logger.debug ("* UsersController.get_scope - cur_scope in: #{cur_scope.inspect.to_s}, show_deactivated?: #{show_deactivated?}")
    cur_scope = Default.scoped if (cur_scope.nil?)
    return (defined?(super)) ? super(cur_scope) : cur_scope
  end

  # GET /defaults
  def index
    @defaults = get_scope().order('store ASC, name ASC')
  end

  # GET /defaults/:id
  def show
    @default = get_scope().find(params[:id])
  end

  # GET /defaults/new
  def new
    @default = Default.new
  end

  # GET /defaults/:id/edit
  def edit
    @default = get_scope().find(params[:id])
  end

  # POST /defaults
  def create
    @default = Default.new(params[:default])
    if @default.save
      # redirect_to @default, notice: 'Default was successfully created.'
      render :action => 'show'
    else
      render :action => "new"
    end
  end

  # PUT /defaults/:id
  def update
    super # call to parent (e.g. Controllers::DeactivatedController)
  end

  # DELETE /defaults/:id
  def destroy
    super # call to parent (e.g. Controllers::DeactivatedController)
  end

end
