require 'spec_helper'
include UserTestHelper
require 'capybara_spec_helper'
include ApplicationHelper


describe HomeController do
  
  before(:each) do
    @user1 = FactoryGirl.create(:user_min_create_attr)
    @model = User.new
  end

  context 'sessions should timeout' do
  
    it 'should load session information into the user_session' do
      session[:current_user_id] = @user1.id
      session[:time_last_accessed] = 2.hours.ago
      @user_session = UserSession.new (session)
      @user_session.errors.count.should == 0
      # no errors in session timeout - messes up action flows
      #@user_session.errors.count.should == 1
      #@user_session.errors.each do |attr, msg|
      #  msg.should == I18n.translate('users_sessions.messages.session_timeout')
      #end
      @user_session.current_user_id.should == 0
      @user_session.signed_in?.should be_false
    end
  
    it 'should time out a signed in session after expiring' do
      @user_session = UserSession.new
      @user_session.sign_in(FactoryGirl.attributes_for(:user_session)[:username], FactoryGirl.attributes_for(:user_session)[:password])
      @user_session.signed_in?.should be_true
      @user_session.expire_user_session
      @user_session.signed_in?.should be_false
    end
  
    it 'should be able to get the user_session information into the session' do
      @user_session = UserSession.new
      @user_session.sign_in(FactoryGirl.attributes_for(:user_session)[:username], FactoryGirl.attributes_for(:user_session)[:password])
      session[:current_user_id] = @user_session.current_user_id
      session[:time_last_accessed] = Time.now
      session[:current_user_id].should == @user1.id
    end
  
  end

end