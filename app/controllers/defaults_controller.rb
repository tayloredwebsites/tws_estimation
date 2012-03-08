class DefaultsController < SecureApplicationController

  # allow records to be deactivated using extras/controllers/deactivated_controller.rb
  include Controllers::DeactivatedController
  
  def initialize
    # this is within the maintenance sub-application
    @systemc = 'maint'
    Rails.logger.debug("* DefaultsController.initialize - @systemc:#{@systemc}")
    super
  end

  before_filter do |controller|
    # no actions require authentication (so far)
    # self.authenticate_user if (%w{ reset_password }.index(params[:action]).nil?)
    @model = Default.new
    @defaults_scoped = get_scope(Default.scoped)
    # Rails.logger.debug("* DefaultsController.before_filter @defaults_scoped:#{@defaults_scoped.inspect.to_s}")
  end

  # chain current scope with any modules that have set scope (e.g. DeactivatedController)
  def get_scope(cur_scope = nil)
    # Rails.logger.debug ("* UsersController.get_scope - cur_scope in: #{cur_scope.inspect.to_s}, show_deactivated?: #{show_deactivated?}")
    cur_scope = Default.scoped if (cur_scope.nil?)
    return (defined?(super)) ? super(cur_scope) : cur_scope
  end

  # GET /defaults
  def index
    # @defaults = Default.all
    @defaults = get_scope().order('store ASC, name ASC')
  end

  # GET /defaults/1
  def show
    @default = get_scope().find(params[:id])
  end

  # GET /defaults/new
  def new
    @default = Default.new
  end

  # GET /defaults/#/edit
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
      render :action => "edit"
    end
  end

  # PUT /defaults/#
  def update
    super # call to parent (e.g. Controllers::DeactivatedController)
  end

  # DELETE /defaults/#
  def destroy
    super # call to parent (e.g. Controllers::DeactivatedController)
  end

end
