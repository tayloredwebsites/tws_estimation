# spec/models/user_spec.rb
require 'spec_helper'
include UserTestHelper

describe UserSession do

    
  context 'sign_in - ' do

    before(:each) do
      @user1 = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
      @model = User.new
      @user_session = UserSession.new
    end

    it 'should start as signed_out' do    
      @user_session.signed_in?.should be_false
    end

    it 'validate test environment - error then need a rake db:test:prepare' do
      @user_count = User.where(:username => FactoryGirl.attributes_for(:user_session)[:username] ).count
      @user_count.should == 1
    end
    
    it 'current_user_id should return the current_user_id' do
      @user_session.sign_in(FactoryGirl.attributes_for(:user_session)[:username], FactoryGirl.attributes_for(:user_session)[:password])
      @user_session.current_user_id.should == @user1.id
    end
    
    it 'signed_in? should be true' do
      @user_session.sign_in(FactoryGirl.attributes_for(:user_session)[:username], FactoryGirl.attributes_for(:user_session)[:password])
      @user_session.signed_in?.should be_true
    end
  
  end
  
  context 'sign_out - ' do
    
    before(:each) do
      @user1 = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
      @model = User.new
      @user_session = UserSession.new
      @user_session.sign_in(FactoryGirl.attributes_for(:user_session)[:username], FactoryGirl.attributes_for(:user_session)[:password])
      @user_session.current_user_id.should == @user1.id
      @user_session.sign_out
    end
    
    it 'should start as signed_out' do    
      @user_session.signed_in?.should be_false
    end

    it 'current_user should return a nil user' do
      @user_session.current_user_id.should == 0
    end
    
    it 'signed_in? should be false' do
      @user_session.signed_in?.should be_false
    end
  
  end
  
  context 'Signed in User - ' do
    
    it 'should clear out sessions that have timed out' do
      @user1 = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
      @model = User.new
      @user_session = UserSession.new
      @user_session.sign_in(FactoryGirl.attributes_for(:user_session)[:username], FactoryGirl.attributes_for(:user_session)[:password])
      @user_session.signed_in?.should be_true
      @user_session.expire_user_session
      @user_session.signed_in?.should be_false
    end
    
    
    it 'should not be able to set invalid values into session (per VALID_SESSION_INFO in app_constants.rb)' do
      @user_session = UserSession.new({:invalid_key => 'invalid value', :current_user_id => 99999})
      @user_session.info(:invalid_key).should be_nil
      @user_session.info(:current_user_id).should == 99999
    end

  end
  
  
end