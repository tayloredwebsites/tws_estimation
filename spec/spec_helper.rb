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
    @defaults = [default1, default2, default_fixed]
    @default = default2
    @default_fixed = default_fixed
    Rails.logger.debug("T UserTestHelper.helper_load_defaults - done")
  end
  def helper_load_component_types
    component_type0 = ComponentType.create!(FactoryGirl.attributes_for(:component_type))
    component_type_hours = ComponentType.create!(FactoryGirl.attributes_for(:component_type_hours).merge(:description => 'Test Hours'))
    component_type_deact = ComponentType.create!(FactoryGirl.attributes_for(:component_type).merge(:deactivated => DB_TRUE))
    component_type_not_in_grid = ComponentType.create!(FactoryGirl.attributes_for(:component_type_not_in_totals_grid).merge(:description => 'Test Not In Grid'))
    component_type_x = ComponentType.create!(FactoryGirl.attributes_for(:component_type))
    component_type_totals = ComponentType.create!(FactoryGirl.attributes_for(:component_type_totals).merge(:description => 'Test Totals Grid'))
    @component_types = [component_type0, component_type_hours, component_type_deact, component_type_not_in_grid, component_type_x, component_type_totals]
    @component_type = component_type0
    @component_type_totals = component_type_totals
    Rails.logger.debug("T UserTestHelper.helper_load_component_types - done")
  end
  def helper_load_components
    helper_load_defaults if !defined?(@defaults)
    helper_load_component_types if !defined?(@component_types)
    component0 = FactoryGirl.create(:component_create, component_type: @component_types[0], default: @defaults[0])
    component1 = FactoryGirl.create(:component_create, component_type: @component_types[1], default: @defaults[1])
    component2 = FactoryGirl.create(:component_create, component_type: @component_types[1])
    component3 = FactoryGirl.create(:component_create, component_type: @component_types[0], default: @defaults[0])
    component4 = FactoryGirl.create(:component_create, component_type: @component_types[1], default: @defaults[1])
    component5 = FactoryGirl.create(:component_create, component_type: @component_types[2]) # note that @component_types[2] is deactivated in helper_load_component_types
    component6 = FactoryGirl.create(:component_create, component_type: @component_types[3], default: @defaults[0])
    component7 = FactoryGirl.create(:component_create, component_type: @component_types[3], default: @defaults[1])
    component8 = FactoryGirl.create(:component_create, component_type: @component_types[3])
    # items in required (totals section), including a non-calculation entry (component9)
    component9 = FactoryGirl.create(:component_create, component_type: @component_types[0], default: @defaults[0])
    component10 = FactoryGirl.create(:component_totals_editable_create, component_type: @component_type_totals, subtotal_group: "one", default: @defaults[0], operation: '*A')
    component11 = FactoryGirl.create(:component_totals_create, component_type: @component_type_totals, subtotal_group: "one", default: @default_fixed, operation: '*I')
    component12 = FactoryGirl.create(:component_totals_editable_create, component_type: @component_type_totals, subtotal_group: "two", operation: '*H')
    component13 = FactoryGirl.create(:component_totals_editable_create, component_type: @component_type_totals, subtotal_group: "two", operation: '*S')
    component14 = FactoryGirl.create(:component_totals_editable_create, component_type: @component_type_totals, subtotal_group: "two") # default operation should be *C
    component15 = FactoryGirl.create(:component_totals_editable_create, component_type: @component_type_totals, subtotal_group: "two", operation: '*H')
    component16 = FactoryGirl.create(:component_totals_editable_create, component_type: @component_type_totals, subtotal_group: "three", operation: '*A')
    component17 = FactoryGirl.create(:component_totals_editable_create, component_type: @component_type_totals, subtotal_group: "three", operation: '*A')
    component_deact = FactoryGirl.create(:component_create, component_type: @component_types[0], deactivated: true)
    @components = [component0, component1, component2, component3, component4, component5, component6, component7, component8, component9, component10, component11, component12, component13, component14, component15, component16, component17, component_deact]
    @component = component1
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
  def helper_load_assembly_components
    helper_load_assemblies if !defined?(@assemblies)
    helper_load_components if !defined?(@components)
    assembly_component0 = FactoryGirl.create(:assembly_component_create, assembly: @assemblies[0], component: @components[0])
    assembly_component1 = FactoryGirl.create(:assembly_component_create, assembly: @assemblies[1], component: @component_deact) # note @component_deact is deactivated -> @assembly_components[1] should not be listed in the new form
    assembly_component2 = FactoryGirl.create(:assembly_component_create, assembly: @assemblies[1], component: @components[1])
    assembly_component3 = FactoryGirl.create(:assembly_component_create, assembly: @assemblies[1], component: @components[2])
    assembly_component4 = FactoryGirl.create(:assembly_component_create, assembly: @assembly_all, component: @components[3])
    assembly_component5 = FactoryGirl.create(:assembly_component_create, assembly: @assembly_all, component: @components[4])
    assembly_component6 = FactoryGirl.create(:assembly_component_create, assembly: @assembly_all, component: @components[5]) # note @components[5] has a component type that is deactivated -> @assembly_components[6] should not be listed in the new form
    assembly_component7 = FactoryGirl.create(:assembly_component_create, assembly: @assembly_all, component: @components[6])
    assembly_component8 = FactoryGirl.create(:assembly_component_create, assembly: @assembly_all, component: @components[7])
    assembly_component9 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[9])
    assembly_component10 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[10])
    assembly_component11 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[11])
    assembly_component12 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[12])
    assembly_component13 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[13])
    assembly_component14 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[14])
    assembly_component15 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[15])
    assembly_component16 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[16])
    assembly_component17 = FactoryGirl.create(:assembly_component_totals_create, assembly: @assembly_total, component: @components[17], deactivated: true)
    @assembly_components = [assembly_component0, assembly_component1, assembly_component2, assembly_component3, assembly_component4, assembly_component5, assembly_component6, assembly_component7, assembly_component8, assembly_component9, assembly_component10, assembly_component11, assembly_component12, assembly_component13, assembly_component14, assembly_component15, assembly_component16, assembly_component17]
    @assembly_component = assembly_component1
    @assembly_component_deact1 = assembly_component1
    @assembly_component_deact2 = assembly_component6
    @assembly_component_deact3 = assembly_component17
    Rails.logger.debug("TTTTTT @assembly_component_deact3 = #{@assembly_component_deact3.inspect.to_s}")
    Rails.logger.debug("T UserTestHelper.helper_load_assembly_components - done")
  end
  
end
