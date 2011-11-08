# spec/models/user_spec.rb
require 'spec_helper'
# include UserTestHelper

describe User do

  before(:each) do
    @user1 = FactoryGirl.create(:admin_user_min_create_attr)
    @model = User.new
  end
  
  it 'deactivate method should deactivate an active user' do
    @user1.deactivated.should be_false
    @user1.deactivate
    @user1.errors.count.should == 0
    @user1.errors.count.should be == 0
    @updated_user = User.find(@user1.id)
    @updated_user.deactivated.should be_true
  end

  it 'reactivate method should reactivate a deactivated user' do
    @user1.deactivated.should be_false
    @user1.deactivate
    @user1.errors.count.should == 0
    @updated_user = User.find(@user1.id)
    @updated_user.deactivated.should be_true
    @user1.reactivate
    @user1.errors.count.should be == 0
    @updated_user = User.find(@user1.id)
    @updated_user.deactivated.should be_false
  end

  it 'reactivate method should not reactivate an active user' do
    @user1.deactivated.should be_false
    @user1.reactivate
    @user1.errors.count.should be > 0
    @user1.errors[:deactivated].should == ["#{I18n.translate('error_messages.is_active')}"]
    @updated_user = User.find(@user1.id)
    @updated_user.deactivated.should be_false
  end

  it 'deactivate method should not deactivate a deactivated user' do
    @user1.deactivated.should be_false
    @user1.deactivate
    @user1.errors.count.should == 0
    @updated_user = User.find(@user1.id)
    @updated_user.deactivated.should be_true
    @user1.deactivate
    @user1.errors.count.should be > 0
    @user1.errors[:deactivated].should == ["#{I18n.translate('error_messages.is_deactivated')}"]
    @user1.errors[:base].should == ["#{I18n.translate('errors.cannot_method_msg', :method => 'deactivate', :msg => I18n.translate('error_messages.is_deactivated') )}"]
    @updated_user = User.find(@user1.id)
    @updated_user.deactivated.should be_true
  end

  it 'destroy should not destroy an active user' do
    @user1.deactivated.should be_false
    @user_id = @user1.id
    @user1.destroy
    @user1.errors.count.should be > 0
    @user1.errors[:deactivated].should == ["#{I18n.translate('error_messages.is_active')}"]
    @user1.errors[:base].should == ["#{I18n.translate('errors.cannot_method_msg', :method => 'destroy', :msg => I18n.translate('error_messages.is_active') )}"]
    @updated_user = User.find(@user_id)
    @updated_user.should_not be_nil
    @updated_user.deactivated.should be_false
  end
  
  it 'destroy should destroy a deactivated user' do
    @user1.deactivated.should be_false
    @user1.deactivate
    @user1.errors.count.should == 0
    @updated_user = User.find(@user1.id)
    @updated_user.deactivated.should be_true
    @user_id = @user1.id
    @user1.destroy
    @user1.errors.count.should be == 0
    lambda {User.find(@user_id)}.should raise_error(ActiveRecord::RecordNotFound)
    # # refresh the user from the database
    # @updated_user = User.find(@user_id)
    # #confirm the user has been deactivated
    # @updated_user.should be_nil
  end
  
  it 'delete should not delete an active user' do
    @user1.deactivated.should be_false
    @user_id = @user1.id
    @user1.delete
    @user1.errors.count.should be > 0
    @user1.errors[:base].should == ["#{I18n.translate('errors.cannot_method_msg', :method => 'delete', :msg => I18n.translate('error_messages.is_active') )}"]
    @user1.errors[:deactivated].should == ["#{I18n.translate('error_messages.is_active')}"]
    @updated_user = User.find(@user_id)
    @updated_user.should_not be_nil
    @updated_user.deactivated.should be_false
  end
  
  it 'delete should delete a deactivated user' do
    @user1.deactivated.should be_false
    @user1.deactivate
    @user1.errors.count.should be == 0
    @updated_user = User.find(@user1.id)
    @updated_user.deactivated.should be_true
    @user_id = @user1.id
    @user1.delete
    @user1.errors.count.should be == 0
    lambda {User.find(@user_id)}.should raise_error(ActiveRecord::RecordNotFound)
    # # refresh the user from the database
    # @updated_user = User.find(@user_id)
    # #confirm the user has been deactivated
    # @updated_user.should be_nil
  end
  
  context "parameter validations -" do

    it "should raise an error create user with no attributes" do
      @num_users = User.count
      lambda {User.create!()}.should raise_error(ActiveRecord::RecordInvalid)
      User.count.should == (@num_users)
    end
    
    it "should not create user when created with no attributes" do
      @num_users = User.count
      user = User.create()
      user.should be_instance_of(User)
      user.username.should be_nil
      user.id.should be_nil
      user.errors.count.should > 0
      User.count.should == (@num_users)
    end
    
    it "should create user when created with the minimum_attributes" do
      @num_users = User.count
      user = User.create(FactoryGirl.attributes_for(:reg_user_min_create_attr))
      user.should be_instance_of(User)
      user.username.should == FactoryGirl.attributes_for(:reg_user_min_create_attr)[:username]
      user.id.should_not be_nil
      user.errors.count.should == 0
      User.count.should == (@num_users+1)
    end
    
    it "should not create user when created without password" do
      @num_users = User.count
      user = User.create(FactoryGirl.attributes_for(:reg_user_min_create_attr).delete(:password))
      user.should be_instance_of(User)
      user.username.should == nil
      user.password.should be_nil
      user.id.should be_nil
      user.errors.count.should > 0
      User.count.should == (@num_users)
    end
    
    it "should not create user when created without password_confirmation" do
      @num_users = User.count
      user = User.create(FactoryGirl.attributes_for(:reg_user_min_create_attr).delete(:password_confirmation))
      user.should be_instance_of(User)
      user.username.should == nil
      user.password_confirmation.should be_nil
      user.id.should be_nil
      user.errors.count.should > 0
      User.count.should == (@num_users)
    end
    
    it 'should not create user when created without a minimum (required) attribute' do
      FactoryGirl.attributes_for(:reg_user_min_attr).each do |key, value|
        test_attributes = FactoryGirl.attributes_for(:reg_user_min_create_attr)
        test_attributes.delete(key)
        # confirm we have a reduced size set of attributes
        FactoryGirl.attributes_for(:reg_user_min_create_attr).size.should == (test_attributes.size+1)
        @num_users = User.count
        user = User.create test_attributes
        user.should be_instance_of(User)
        user[key].should be_nil
        user.id.should be_nil
        user.errors.count.should > 0
        User.count.should == (@num_users)
      end
    end
    
    it 'should create user when created with safe_attributes' do
      @num_users = User.count
      user = User.create!(FactoryGirl.attributes_for(:users_create).merge(:first_name => FactoryGirl.attributes_for(:user_safe_attr)[:first_name]))
      User.count.should == (@num_users+1)
      @num_users = User.count
      user = User.create!(FactoryGirl.attributes_for(:users_create).merge(:last_name => FactoryGirl.attributes_for(:user_safe_attr)[:last_name]))
      User.count.should == (@num_users+1)
      @num_users = User.count
      user = User.create!(FactoryGirl.attributes_for(:users_create).merge(:username => FactoryGirl.attributes_for(:user_safe_attr)[:username]))
      User.count.should == (@num_users+1)
    end

    it 'should create user when created without any unsafe_attributes' do
      FactoryGirl.attributes_for(:user_unsafe_attr).each do |key, value|
        @num_users = User.count
        user = User.create(FactoryGirl.attributes_for(:reg_user_min_create_attr).merge({key => value}))
        user.should_not be_nil
        user.should be_instance_of(User)
        user[key].should be_nil
        user.errors.count.should == 0
        User.count.should == (@num_users+1)
      end
    end

    it "should ignore invalid attributes when creating a user" do
      @num_users = User.count
      user = User.create!(FactoryGirl.attributes_for(:users_create).merge(:first_name => FactoryGirl.attributes_for(:user_inval_attr)[:admin]))
      user.should_not respond_to(:admin)
      User.count.should == (@num_users+1)
      @num_users = User.count
      user = User.create!(FactoryGirl.attributes_for(:users_create).merge(:last_name => FactoryGirl.attributes_for(:user_inval_attr)[:foo]))
      user.should_not respond_to(:foo)
      User.count.should == (@num_users+1)
      @num_users = User.count
      user = User.create!(FactoryGirl.attributes_for(:users_create).merge(:username => FactoryGirl.attributes_for(:user_inval_attr)[:bar]))
      user.should_not respond_to(:bar)
      User.count.should == (@num_users+1)
      @num_users = User.count
    end
    it 'should allow the user to update their passwords' do
      user = User.create(FactoryGirl.attributes_for(:user_min_create_attr))
      user.update_attributes(FactoryGirl.attributes_for(:user_update_password_attr) )
      user.errors.count.should == 0
      user.has_password?(FactoryGirl.attributes_for(:user_update_password_attr)[:password]).should be_true
      # user.errors[:password].should == ["#{I18n.translate('error_messages.invalid_password')}"]
      # user.errors[:base].should == ["#{I18n.translate('obj_does_not_exist', 'user')}"]
      updated_user = User.find(user.id)
      updated_user.has_password?(FactoryGirl.attributes_for(:user_update_password_attr)[:password]).should be_true
    end
    it 'should be able to reset_password' do
      user = User.create(FactoryGirl.attributes_for(:user_min_create_attr))
      user.reset_password
      user.update_attributes(:id => user.id)
      user.errors.count.should == 0
      updated_user = User.find(user.id)
      # should not have the old password any more
      updated_user.has_password?(FactoryGirl.attributes_for(:user_min_create_attr)[:password]).should be_false
    end
    it 'should accept valid email addresses using VALID_EMAIL_EXPR application constant' do
      # %w{ test@controlledair.com test@testing.com test@me.com test@gmail.com test@example.com 1@me.com}.each do |email_addr|
      #   @user_count = User.count
      #   a_user = User.create(FactoryGirl.attributes_for(:reg_user_min_create_attr).merge(:email => email_addr) )
      #   User.count.should == @user_count+1
      # end
      @user_count = User.count
      a_user = User.create(FactoryGirl.attributes_for(:users_create).merge(:email => 'test@controlledair.com') )
      User.count.should == @user_count+1
      @user_count = User.count
      a_user = User.create(FactoryGirl.attributes_for(:users_create).merge(:email => 'test@me.com') )
      User.count.should == @user_count+1
      @user_count = User.count
      a_user = User.create(FactoryGirl.attributes_for(:users_create).merge(:email => 'test@gmail.com') )
      User.count.should == @user_count+1
      @user_count = User.count
      a_user = User.create(FactoryGirl.attributes_for(:users_create).merge(:email => 'test@example.com') )
      User.count.should == @user_count+1
      @user_count = User.count
      a_user = User.create(FactoryGirl.attributes_for(:users_create).merge(:email => '1@me.com') )
      User.count.should == @user_count+1
    end
    it 'should reject invalid email addresses using VALID_EMAIL_EXPR application constant' do
      # %w{ test@testing.com a.b.com me@yahoo.com hello }.each do |email_addr|
      #   @user_count = User.count
      #   a_user = User.create!(FactoryGirl.attributes_for(:reg_user_min_create_attr).merge(:email => email_addr) )
      #   User.count.should == @user_count
      # end
      @user_count = User.count
      a_user = User.create(FactoryGirl.attributes_for(:users_create).merge(:email => 'test@testing.com') )
      User.count.should == @user_count
      a_user = User.create(FactoryGirl.attributes_for(:users_create).merge(:email => 'a.b.com') )
      User.count.should == @user_count
      a_user = User.create(FactoryGirl.attributes_for(:users_create).merge(:email => 'me@yahoo.com') )
      User.count.should == @user_count
      a_user = User.create(FactoryGirl.attributes_for(:users_create).merge(:email => 'hello') )
      User.count.should == @user_count
    end
    it 'should reject an email that is not unique' do
      @user_count = User.count
      user = User.create(FactoryGirl.attributes_for(:users_create).merge(:email => 'test@example.com') )
      # user.errors.each do |type, msg|
      #   msg.should == ''
      # end
      user.errors.count.should == 0
      User.count.should == @user_count+1
      @user_count = User.count
      user = User.create(FactoryGirl.attributes_for(:users_create).merge(:email => 'test@example.com') )
      user.errors.count.should > 0
      User.count.should == @user_count
    end
    it 'should reject a username is not unique' do
      @user_count = User.count
      user = User.create(FactoryGirl.attributes_for(:users_create).merge(:username => 'MyName') )
      user.errors.count.should == 0
      User.count.should == @user_count+1
      @user_count = User.count
      user = User.create(FactoryGirl.attributes_for(:users_create).merge(:username => 'MyName') )
      user.errors.count.should > 0
      User.count.should == @user_count
    end

  end
  
  it 'should should have accessible attributes and methods' do
    FactoryGirl.attributes_for(:reg_user_min_create_attr).each do |key, value|
      @user1.should respond_to(key)
    end
    FactoryGirl.attributes_for(:user_safe_attr).each do |key, value|
      @user1.should respond_to(key)
    end
    @user1.should respond_to(:password)
    @user1.should respond_to(:password_confirmation)
    @user1.should respond_to(:encrypted_password)
    @user1.should respond_to(:password_salt)
    User.should respond_to(:valid_password?)
  end

  context 'logged in regular user -' do
    
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:reg_user_min_create_attr))
      @model = User.new
      @user_session = UserSession.new
      @user_session.sign_in(FactoryGirl.attributes_for(:reg_user_session)[:username], FactoryGirl.attributes_for(:reg_user_session)[:password])
      @user_session.current_user_id.should == @me.id
    end
    it 'should allow the user to update their passwords' do
      # check that update_password does
      user = FactoryGirl.create(:user_min_create_attr)
      user.has_password?(FactoryGirl.attributes_for(:user_min_create_attr)[:password]).should be_true
      password_attribs = {
        :old_password => FactoryGirl.attributes_for(:user_min_create_attr)[:password],
        :password => 'NewPass',
        :password_confirmation => 'NewPass'
      }
      user.valid_password_change?(password_attribs).should be_true
      user.errors.count.should == 0
      # process that both update_password and update use
      user.update_attributes(password_attribs)
      user.has_password?(FactoryGirl.attributes_for(:user_min_create_attr)[:password]).should be_false
      updated_user = User.find(user.id)
      updated_user.has_password?('NewPass').should be_true
    end
    
  end
  
end

# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  email              :string(255)
#  roles              :string(255)
#  username           :string(255)
#  encrypted_password :string(255)
#  password_salt      :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

