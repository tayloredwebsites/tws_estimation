class EstimateAssembliesController < SecureApplicationController

  # allow records to be deactivated using extras/controllers/deactivated_controller.rb
  # include Controllers::DeactivatedController
  
  def initialize
    # this is within the estimation maintenance sub-application
    @systemc = 'estimmaint'
    Rails.logger.debug("* EstimateAssembliesController.initialize - @systemc:#{@systemc}")
    super
  end

  before_filter do |controller|
    self.authenticate_user # always authenticate user   if (%w{ index show }.index(params[:action]).nil?)
  end
  
  def self.list(scope = nil)
    list_scope = (scope.nil?) ? self.new.get_scope() : scope
    list_scope.joins(:estimate).joins(:assembly).order('assemblies.sort_order, estimate.title')
  end

  # chain current scope with any modules that have set scope (e.g. DeactivatedController)
  def get_scope(cur_scope = nil)
    # base default scope is set up here so that deactivated module can update this
    cur_scope = EstimateAssembly.scoped if (cur_scope.nil?)
    return (defined?(super)) ? super(cur_scope) : cur_scope
  end

end
