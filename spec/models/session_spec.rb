# spec/models/user_spec.rb
require 'spec_helper'
include UserTestHelper

describe UserSession do

  before(:each) do
    @user1 = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
    @model = User.new
    @user_session = UserSession.new
  end
  
  it 'should start as signed_out' do    
    @user_session.signed_in?.should be_false
  end
    
  context 'sign_in - ' do
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
      @user_session.sign_in(FactoryGirl.attributes_for(:user_session)[:username], FactoryGirl.attributes_for(:user_session)[:password])
      @user_session.current_user_id.should == @user1.id
      @user_session.sign_out
    end
    
    it 'current_user should return a nil user' do
      @user_session.current_user_id.should be_nil
    end
    
    it 'signed_in? should be false' do
      @user_session.signed_in?.should be_false
    end
  
  end
  
  
end