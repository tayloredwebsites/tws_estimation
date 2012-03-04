class DefaultsController < SecureApplicationController

  # allow records to be deactivated
  include Controllers::DeactivatedController
  
  load_and_authorize_resource # cancan feature to pre-populate @defaults or @default instance variable !

  def initialize
    # this is within the maintenance sub-application
    @systemc = 'maint'
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
  def get_scope(cur_scope)
    # Rails.logger.debug ("* UsersController.get_scope - cur_scope in: #{cur_scope.inspect.to_s}, show_deactivated?: #{show_deactivated?}")
    cur_scope = Default.scoped if (cur_scope.nil?)
    return (defined?(super)) ? super(cur_scope) : cur_scope
  end
  
  # GET /defaults
  def index
    # @defaults = Default.all
  end

  # GET /defaults/1
  def show
    # @default = Default.find(params[:id])
  end

  # GET /defaults/new
  def new
    # @default = Default.new
  end

  # GET /defaults/#/edit
  def edit
    # @default = Default.find(params[:id])
  end

  # POST /defaults
  def create
    # @default = Default.new(params[:default])
    if @default.save
      redirect_to @default, notice: 'Default was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /defaults/#
  def update
    # @default = Default.find(params[:id])
    if @default.update_attributes(params[:default])
      redirect_to @default, notice: 'Default was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /defaults/#
  def destroy
    @default = Default.find(params[:id])
    @default.destroy

    redirect_to defaults_url
  end

end
