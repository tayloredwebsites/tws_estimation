# spec/models/user_spec.rb
require 'spec_helper'
include UserTestHelper

describe Session do

  before(:each) do
    @user1 = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
    @model = User.new
    @session = Session.new
  end
  
  it 'should start as signed_out' do    
    @session.signed_in?.should be_false
    @session.signed_in_at.should be_nil
  end
    
  context 'sign_in - ' do
    
   it 'current_user_id should return the current_user_id' do
      @session.sign_in(FactoryGirl.attributes_for(:user_session)[:username], FactoryGirl.attributes_for(:user_session)[:password])
      @session.current_user_id.should == @user1.id
      @session.signed_in_at.should_not be_nil
    end
    
    it 'logged_in? should be true' do
      @session.sign_in(FactoryGirl.attributes_for(:user_session)[:username], FactoryGirl.attributes_for(:user_session)[:password])
      @session.signed_in?.should be_true
      @session.signed_in_at.should_not be_nil
    end
  
  end
  
  context 'sign_out - ' do
    
    before(:each) do
      @session.sign_in(FactoryGirl.attributes_for(:user_session)[:username], FactoryGirl.attributes_for(:user_session)[:password])
      @session.current_user_id.should == @user1.id
      @session.sign_out
    end
    
    it 'current_user should return a nil user' do
      @session.current_user_id.should be_nil
      @session.signed_in_at.should be_nil
    end
    
    it 'logged_in? should be false' do
      @session.signed_in?.should be_false
      @session.signed_in_at.should be_nil
    end
  
  end
  
  
end