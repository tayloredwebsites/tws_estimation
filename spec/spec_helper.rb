require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

end

Spork.each_run do
  # This code will be run each time you run your specs.

end

# --- Instructions ---
# - Sort through your spec_helper file. Place as much environment loading
#   code that you don't normally modify during development in the
#   Spork.prefork block.
# - Place the rest under Spork.each_run block
# - Any code that is left outside of the blocks will be ran during preforking
#   and during each_run!
# - These instructions should self-destruct in 10 seconds.  If they don't,
#   feel free to delete them.
#




# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
# require 'rspec/autorun'

# Add this to load Capybara integration:
require 'capybara/rspec'
require 'capybara/rails'

# testing using sqlite3 in memory database - force schema to load
# # http://www.osmonov.com/2011/01/in-memory-sqlite-database-for-testing.html
# load_schema = lambda {
#     load "#{::Rails.root}/db/schema.rb" # use db agnostic schema by default
#     # ActiveRecord::Migrator.up('db/migrate') # use migrations
#   }
#   silence_stream(STDOUT, &load_schema)
if in_memory_database?
  in_memory_load_db_schema(false)
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# turn off javascript for testing
VIEWS_SCRIPTING = false

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = true

  # fix for records not being removed after capybara fill in and click
  # per http://stackoverflow.com/questions/6576592/failing-to-test-devise-with-capybara
  # requires the database_cleaner gem
  config.use_transactional_fixtures = false
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end

  # doesn't work under rails 3.2 new configuration
  # specify logger and set to debug
  # config.logger = Logger.new(STDOUT)
  # config.log_level = :debug

  # per: http://stackoverflow.com/questions/8862967/visit-method-not-found-in-my-rspec
  # to solve: Failure/Error: helper_signin(:admin_user_full_create_attr, @me.full_name)
  #           NoMethodError:
  #             undefined method `visit' for #<RSpec::Core::ExampleGroup::Nested_10::Nested_1:0x007f8782cb2850>
  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers

  # precompile assets before running test suite
  # see: http://stackoverflow.com/questions/13484808/save-and-open-page-not-working-with-capybara-2-0
  config.before (scope = :suite) do
    %x[bundle exec rake assets:precompile]
  end

end

module SpecHelper
  # common steps in any tests

  # list of fields that are to be required (to confirm Presence Validator)
  REQUIRED_STATE_COMPONENT_TYPE_TAX_FIELDS = [:state, :state_id, :job_type, :job_type_id, :component_type, :component_type_id, :tax_percent]
  # REQUIRED_STATE_COMPONENT_TYPE_TAX_FIELDS = [:state, :job_type, :component_type, :tax_percent]

  # method to include associations into Factory Girl Builds
  def build_attributes(*args)
    FactoryGirl.build(*args).attributes.delete_if do |k, v|
      ["id", "created_at", "updated_at"].member?(k)
    end
  end
end

module UserTestHelper
  # signin capability for controller tests
  def session_signin(username, password)
    Rails.logger.debug("T UserTestHelper.session_signin")
    session[:current_user_id] = 0
    @user_session = UserSession.new (session)
    @user_session.sign_in(username, password)
    if @user_session.signed_in?
      session[:current_user_id] = @user_session.current_user_id
      session[:time_last_accessed] = @user_session.time_last_accessed
    end
    Rails.logger.debug("T UserTestHelper.session_signin - done - signed_in?: #{@user_session.signed_in?}")
    return @user_session
  end
  def session_signout()
    Rails.logger.debug("T UserTestHelper.session_signout")
    session[:current_user_id] = 0
    @user_session = UserSession.new (session)
    Rails.logger.debug("T UserTestHelper.session_signin - done")
    return @user_session
  end
  def allow_admin_set_password(true_or_false)
    # allows tests to test both of the valid ADMIN_SET_USER_PASSWORD application constant settings
    if true_or_false.is_a?(FalseClass) || true_or_false.is_a?(TrueClass)
      @saved_ADMIN_SET_USER_PASSWORD = ADMIN_SET_USER_PASSWORD
      # Rails.logger.debug("TTT @saved_ADMIN_SET_USER_PASSWORD = #{@saved_ADMIN_SET_USER_PASSWORD}")
      begin
        Object.send(:remove_const, :ADMIN_SET_USER_PASSWORD)
        Object.const_set(:ADMIN_SET_USER_PASSWORD, true_or_false)
      rescue
      end
    else
      Rails.logger.error("T UserTestHelper.allow_admin_set_password sent an invalid value")
    end
  end
  def reset_admin_set_password()
    begin
      # Rails.logger.debug("TTT @saved_ADMIN_SET_USER_PASSWORD = #{@saved_ADMIN_SET_USER_PASSWORD}")
      Object.send(:remove_const, :ADMIN_SET_USER_PASSWORD)
      Object.const_set(:ADMIN_SET_USER_PASSWORD, @saved_ADMIN_SET_USER_PASSWORD)
    rescue
    end
  end


end
module UserIntegrationHelper
  # common steps in integration tests

  def helper_signin(factory_arg, user_full_name)
    visit signin_path
    helper_signin_form_submit(factory_arg)
    helper_user_on_page?('menu_items.guest.full_name', 'users_sessions.index.header', user_full_name)
    Rails.logger.debug("T UserTestHelper.helper_signin - done")
  end
  def helper_signin_form_submit(factory_arg)
    # visit signin_path
    # confirm we are on the signin page
    find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users_sessions.signin.header')}$/
    # should fill in the login form to login
    page.fill_in("user_session[username]", :with => FactoryGirl.attributes_for(factory_arg.to_sym)[:username] )
    page.fill_in('user_session[password]', :with => FactoryGirl.attributes_for(factory_arg.to_sym)[:password] )
    find(:xpath, '//form[@action="/users_sessions"]//input[@type="submit"]').click
    # save_and_open_page
    Rails.logger.debug("T UserTestHelper.helper_signin_form_submit - done")
  end
  def helper_user_on_page?(sys_header_arg, page_header_arg, user_full_name)
    # Rails.logger.debug("T helper_user_on_page - sys_header_arg = #{sys_header_arg} = #{I18n.translate(sys_header_arg)}")
    # Rails.logger.debug("T helper_user_on_page - page_header_arg = #{page_header_arg} =  page_header_arg = #{I18n.translate(page_header_arg)}")
    # Rails.logger.debug("T helper_user_on_page - user_full_name = #{user_full_name}")
    find('#header_tagline_system_header').text.should =~ /^#{I18n.translate(sys_header_arg)}$/ if !sys_header_arg.nil?
    find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate(page_header_arg)}$/ if !page_header_arg.nil?
    find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]').text.should =~
      /#{I18n.translate('view_labels.welcome_user', :user => user_full_name) }/ if !user_full_name.nil?
      Rails.logger.debug("T UserTestHelper.helper_user_on_page - done")
  end
  def helper_load_defaults
    default1 = Default.create!(FactoryGirl.attributes_for(:default))
    default2 = Default.create!(FactoryGirl.attributes_for(:default))
    default_fixed = Default.create!(FactoryGirl.attributes_for(:default, :value => 2.78))
    default_hourly = Default.create!(FactoryGirl.attributes_for(:default, :value => 22.75))
    @defaults = [default1, default2, default_fixed, default_hourly]
    @default = default2
    @default_fixed = default_fixed
    @default_hourly = default_hourly
    Rails.logger.debug("T UserTestHelper.helper_load_defaults - done")
  end
  def helper_load_component_types
    component_type0 = ComponentType.create!(FactoryGirl.attributes_for(:component_type))
    component_type_hours = ComponentType.create!(FactoryGirl.attributes_for(:component_type_hours).merge(:description => 'Test Hours'))
    component_type_deact = ComponentType.create!(FactoryGirl.attributes_for(:component_type).merge(:deactivated => DB_TRUE, :description => 'Deactivated Type'))
    component_type_not_in_grid = ComponentType.create!(FactoryGirl.attributes_for(:component_type_not_in_totals_grid).merge(:description => 'Test Not In Grid'))
    component_type_x = ComponentType.create!(FactoryGirl.attributes_for(:component_type))
    component_type_totals = ComponentType.create!(FactoryGirl.attributes_for(:component_type_totals).merge(:description => 'Test Totals Grid'))
    @component_types = [component_type0, component_type_hours, component_type_deact, component_type_not_in_grid, component_type_x, component_type_totals]
    @component_type = component_type0
    @component_type_hours = component_type_hours
    Rails.logger.debug("*TestHourlyRates* @component_type_hours.id = #{@component_type_hours.id.inspect.to_s}")
    @component_type_totals = component_type_totals
    Rails.logger.debug("T UserTestHelper.helper_load_component_types - done")
  end
  def helper_load_components
    helper_load_defaults if !defined?(@defaults)
    helper_load_component_types if !defined?(@component_types)
    component0 = FactoryGirl.create(:component_create, component_type: @component_types[0], default: @defaults[0])
    component1 = FactoryGirl.create(:component_hourly_create, component_type: @component_type_hours, default: @defaults[1], labor_rate_default: @default_hourly)
    component2 = FactoryGirl.create(:component_hourly_create, component_type: @component_type_hours, labor_rate_default: @default_hourly)
    component3 = FactoryGirl.create(:component_create, component_type: @component_types[0], default: @defaults[0])
    component4 = FactoryGirl.create(:component_hourly_create, component_type: @component_type_hours, default: @defaults[1], labor_rate_default: @default_hourly)
    component5 = FactoryGirl.create(:component_create, component_type: @component_types[2]) # note that @component_types[2] is deactivated in helper_load_component_types
    component6 = FactoryGirl.create(:component_create, component_type: @component_types[3], default: @defaults[0])
    component7 = FactoryGirl.create(:component_create, component_type: @component_types[3], default: @defaults[1])
    component8 = FactoryGirl.create(:component_create, component_type: @component_types[3])
    # items in required (totals section), including a non-calculation entry (component9)
    component9 = FactoryGirl.create(:component_create, component_type: @component_types[0], default: @defaults[0])
    component10 = FactoryGirl.create(:component_totals_editable_create, component_type: @component_type_totals, grid_subtotal: "stot_1", default: @defaults[0], grid_operand: '*', grid_scope: 'A')
    component11 = FactoryGirl.create(:component_totals_create, component_type: @component_type_totals, grid_subtotal: "stot_1", default: @default_fixed, grid_operand: '*', grid_scope: 'I')
    component12 = FactoryGirl.create(:component_totals_editable_create, component_type: @component_type_totals, grid_subtotal: "stot_2", grid_operand: '*', grid_scope: 'A')
    component13 = FactoryGirl.create(:component_totals_editable_create, component_type: @component_type_totals, grid_subtotal: "stot_2", grid_operand: '*', grid_scope: 'S')
    component14 = FactoryGirl.create(:component_totals_editable_create, component_type: @component_type_totals, grid_subtotal: "stot_2")
    component15 = FactoryGirl.create(:component_totals_editable_create, component_type: @component_type_totals, grid_subtotal: "stot_2", grid_operand: '*', grid_scope: 'C')
    component16 = FactoryGirl.create(:component_totals_editable_create, component_type: @component_type_totals, grid_subtotal: "stot_3", grid_operand: '*', grid_scope: 'I')
    component17 = FactoryGirl.create(:component_totals_editable_create, component_type: @component_type_totals, grid_subtotal: "stot_3", grid_operand: '%', grid_scope: 'A')
    component_deact = FactoryGirl.create(:component_create, component_type: @component_types[0], deactivated: true)
    # component14_extra_hourly = FactoryGirl.create(:component_totals_editable_create, component_type: @component_type_totals, grid_subtotal: "stot_2", grid_operand: '*', grid_scope: 'H')
    @components = [component0, component1, component2, component3, component4, component5, component6, component7, component8, component9, component10, component11, component12, component13, component14, component15, component16, component17, component_deact]
    @component = component1
    # @component14_extra_hourly = component14_extra_hourly
    @component_deact = component_deact
    Rails.logger.debug("T UserTestHelper.helper_load_components - done")
  end
  def helper_load_assemblies
    assembly0 = FactoryGirl.create(:assembly_create)
    assembly1 = FactoryGirl.create(:assembly_create)
    assembly2 = FactoryGirl.create(:assembly_required_create)
    assembly3 = FactoryGirl.create(:assembly_required_create)
    assembly_deact = FactoryGirl.create(:assembly_required_create, deactivated: true)
    @assemblies = [assembly0, assembly1, assembly2, assembly3, assembly_deact]
    @assembly = assembly0
    @assembly_all = assembly2
    @assembly_total = assembly3
    @assembly_deact = assembly_deact
    Rails.logger.debug("T UserTestHelper.helper_load_assemblies - done")
  end
  def helper_load_assembly_components()
    helper_load_assemblies if !defined?(@assemblies)
    helper_load_components if !defined?(@components)
    assembly_component0 = FactoryGirl.create(:assembly_component_create, assembly: @assemblies[0], component: @components[0])
    assembly_component1 = FactoryGirl.create(:assembly_component_create, assembly: @assemblies[1], component: @component_deact) # note @component_deact is deactivated -> @assembly_components[1] should not be listed in the new form
    assembly_component2 = FactoryGirl.create(:assembly_component_create, assembly: @assemblies[1], component: @components[1])
    assembly_component3 = FactoryGirl.create(:assembly_component_create, assembly: @assemblies[1], component: @components[2], required: true)
    assembly_component4 = FactoryGirl.create(:assembly_component_create, assembly: @assembly_all, component: @components[3])
    assembly_component5 = FactoryGirl.create(:assembly_component_create, assembly: @assembly_all, component: @components[4])
    assembly_component6 = FactoryGirl.create(:assembly_component_create, assembly: @assembly_all, component: @components[5]) # note @components[5] has a component type that is deactivated -> @assembly_components[6] should not be listed in the new form
    assembly_component7 = FactoryGirl.create(:assembly_component_create, assembly: @assembly_all, component: @components[6], required: true)
    assembly_component8 = FactoryGirl.create(:assembly_component_create, assembly: @assembly_all, component: @components[7])
    assembly_component9 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[9])
    assembly_component10 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[10])
    assembly_component11 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[11]) # not editable
    assembly_component12 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[12])
    assembly_component13 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[13])
    # if load_extra_hourly_conversion
    #   assembly_component14 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @component14_extra_hourly)
    # else
      assembly_component14 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[14])
    # end
    assembly_component15 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[15])
    assembly_component16 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[16], deactivated: true)
    assembly_component17 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[17], required: true)
    @assembly_components = [assembly_component0, assembly_component1, assembly_component2, assembly_component3, assembly_component4, assembly_component5, assembly_component6, assembly_component7, assembly_component8, assembly_component9, assembly_component10, assembly_component11, assembly_component12, assembly_component13, assembly_component14, assembly_component15, assembly_component16, assembly_component17]
    @assembly_component = assembly_component1
    @assembly_component_deact1 = assembly_component1
    @assembly_component_deact2 = assembly_component6
    @assembly_component_deact3 = assembly_component16
    Rails.logger.debug("TTTTTT @assembly_component_deact3 = #{@assembly_component_deact3.inspect.to_s}")
    Rails.logger.debug("T UserTestHelper.helper_load_assembly_components - done")
  end

  def helper_load_tax_test
    @tax_default = Default.create!(FactoryGirl.attributes_for(:default, :value => 2.78))
    @tax_default2 = Default.create!(FactoryGirl.attributes_for(:default, :value => 3.25))
    @tax_defaults = [@tax_default, @tax_default2]

    @tax_component_type = ComponentType.create!(FactoryGirl.attributes_for(:component_type).merge(:description => 'Test Comp Type'))
    @tax_component_type_totals = ComponentType.create!(FactoryGirl.attributes_for(:component_type_totals).merge(:description => 'Test Totals Grid'))
    @tax_component_types = [@tax_component_type, @tax_component_type_totals]

    @tax_component = FactoryGirl.create(:component_create, component_type: @tax_component_type, default: @tax_default)
    @tax_def_component = FactoryGirl.create(:component_create, component_type: @tax_component_type, default: @tax_default)
    @tax_grid_editable_component = FactoryGirl.create(:component_totals_editable_create, component_type: @tax_component_type_totals, grid_subtotal: "stot_1", grid_operand: '*', grid_scope: 'S')
    @tax_grid_non_editable_component = FactoryGirl.create(:component_totals_create, component_type: @tax_component_type_totals, grid_subtotal: "stot_1", default: @tax_default, grid_operand: '*', grid_scope: 'S')
    @tax_components = [@tax_component, @tax_def_component,  @tax_grid_editable_component, @tax_grid_not_editable_component]

    @tax_assembly = FactoryGirl.create(:assembly_required_create)
    @tax_assemblies = [@tax_assembly]

    @tax_assembly_component = FactoryGirl.create(:assembly_component_create, assembly: @tax_assembly, component: @tax_component)
    @tax_assembly_def_component = FactoryGirl.create(:assembly_component_create, assembly: @tax_assembly, component: @tax_def_component)
    @tax_assembly_grid_editable_component = FactoryGirl.create(:assembly_component_create, assembly: @tax_assembly, component: @tax_grid_editable_component)
    @tax_assembly_grid_non_editable_component = FactoryGirl.create(:assembly_component_create, assembly: @tax_assembly, component: @tax_grid_non_editable_component)
    @tax_assembly_components = [@tax_assembly_component, @tax_assembly_def_component, @tax_assembly_grid_editable_component, @tax_assembly_grid_non_editable_component]

    @tax_state = State.create!(FactoryGirl.attributes_for(:state))

    @tax_job_type = JobType.create!(FactoryGirl.attributes_for(:job_type))

    # @tax_type = StateComponentTypeTax.create!(UserIntegrationHelper.build_attributes(:state_component_type_tax, state: @tax_state, job_type: @tax_job_type, component_type: @tax_component_type))

    Rails.logger.debug("T UserTestHelper.helper_load_test_tax - done")
  end
  def helper_load_hourly_tax_test
    # helper_load_tax_test if !defined?(@tax_assemblies)
    @tax_default = Default.create!(FactoryGirl.attributes_for(:default, :value => 2.78))
    @tax_default2 = Default.create!(FactoryGirl.attributes_for(:default, :value => 3.25))
    @tax_default_hourly = Default.create!(FactoryGirl.attributes_for(:default, :name => 'Hourly Rate', :value => 22.75))
    @tax_default_tax_rate = Default.create!(FactoryGirl.attributes_for(:default, :name => 'Tax Rate', :value => 8.25))
    @tax_defaults = [@tax_default, @tax_default2, @tax_default_hourly, @tax_default_tax_rate, @tax_default_hourly]

    @tax_component_type = ComponentType.create!(FactoryGirl.attributes_for(:component_type).merge(:description => 'Test Comp Type'))
    @tax_hourly_component_type = ComponentType.create!(FactoryGirl.attributes_for(:component_type_hours).merge(:description => 'Test Hourly Comp Type'))
    @tax_component_type_totals = ComponentType.create!(FactoryGirl.attributes_for(:component_type_totals).merge(:description => 'Test Totals Grid'))
    @tax_component_types = [@tax_component_type, @tax_hourly_component_type, @tax_component_type_totals]

    @tax_component = FactoryGirl.create(:component_create, component_type: @tax_component_type, default: @tax_default)
    @tax_hourly_def_component = FactoryGirl.create(:component_hourly_create, component_type: @tax_hourly_component_type, default: @tax_default2, labor_rate_default: @tax_default_hourly)
    @tax_hourly_component = FactoryGirl.create(:component_hourly_create, component_type: @tax_hourly_component_type, default: @tax_default2, labor_rate_default: @tax_default_hourly)
    @tax_def_component = FactoryGirl.create(:component_create, component_type: @tax_component_type, default: @tax_default2)
    @tax_grid_editable_component = FactoryGirl.create(:component_totals_editable_create, component_type: @tax_component_type_totals, grid_subtotal: "stot_1", grid_operand: '*', grid_scope: 'I')
    @tax_grid_non_editable_component = FactoryGirl.create(:component_totals_create, component_type: @tax_component_type_totals, grid_subtotal: "stot_1", default: @tax_default, grid_operand: '*', grid_scope: 'I')
    @tax_grid_calc_subtotal_component = FactoryGirl.create(:component_totals_create, component_type: @tax_component_type_totals, grid_subtotal: "stot_2", default: @tax_default, grid_operand: '%', grid_scope: 'S')
    @tax_components = [@tax_component, @tax_hourly_def_component, @tax_hourly_component, @tax_def_component,  @tax_grid_editable_component, @tax_grid_not_editable_component, @tax_grid_calc_subtotal_component]

    @tax_assembly = FactoryGirl.create(:assembly_required_create)
    @tax_assemblies = [@tax_assembly]

    @tax_assembly_component = FactoryGirl.create(:assembly_component_create, assembly: @tax_assembly, component: @tax_component)
    @tax_assembly_hourly_def_component = FactoryGirl.create(:assembly_component_hourly_create, description: 'Hourly Assembly Component 1', assembly: @tax_assembly, component: @tax_hourly_def_component)
    @tax_assembly_hourly_component = FactoryGirl.create(:assembly_component_hourly_create, description: 'Hourly Assembly Component 2', assembly: @tax_assembly, component: @tax_hourly_component)
    @tax_assembly_def_component = FactoryGirl.create(:assembly_component_create, assembly: @tax_assembly, component: @tax_def_component)
    @tax_assembly_grid_editable_component = FactoryGirl.create(:assembly_component_create, assembly: @tax_assembly, component: @tax_grid_editable_component)
    @tax_assembly_grid_non_editable_component = FactoryGirl.create(:assembly_component_create, assembly: @tax_assembly, component: @tax_grid_non_editable_component)
    @tax_assembly_grid_calc_subtotal_component = FactoryGirl.create(:assembly_component_create, assembly: @tax_assembly, component: @tax_grid_calc_subtotal_component)
    @tax_assembly_components = [@tax_assembly_component, @tax_hourly_def_component, @tax_hourly_component, @tax_assembly_def_component, @tax_assembly_grid_editable_component, @tax_assembly_grid_non_editable_component, @tax_assembly_grid_calc_subtotal_component]

    @tax_state = State.create!(FactoryGirl.attributes_for(:state))

    @tax_job_type = JobType.create!(FactoryGirl.attributes_for(:job_type))

    # @tax_type = StateComponentTypeTax.create!(UserIntegrationHelper.build_attributes(:state_component_type_tax, state: @tax_state, job_type: @tax_job_type, component_type: @tax_component_type))

    Rails.logger.debug("T UserTestHelper.helper_load_test_tax - done")
  end
end
