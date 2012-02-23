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


# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

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
    Rails.logger.debug("T UserTestHelper.session_signin - done")
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
    helper_user_on_page?('systems.guest.full_name', 'users_sessions.index.header', user_full_name)
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
  end
  def helper_user_on_page?(sys_header_arg, page_header_arg, user_full_name)
    find('#header_tagline_system_header').text.should =~ /^#{I18n.translate(sys_header_arg)}$/ if !sys_header_arg.nil?
    find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate(page_header_arg)}$/ if !page_header_arg.nil?
    find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]').text.should =~
      /#{I18n.translate('view_labels.welcome_user', :user => user_full_name) }/ if !user_full_name.nil?
  end
  
end
