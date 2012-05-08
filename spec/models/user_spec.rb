# spec/models/user_spec.rb
require 'spec_helper'
# include UserTestHelper

describe User do

  context "parameter validations -" do

    before(:each) do
      @user1 = FactoryGirl.create(:admin_user_min_create_attr)
      @model = User.new
    end

    it "should raise an error create user with no attributes" do
      @num_users = User.count
      lambda {User.create!()}.should raise_error(ActiveRecord::RecordInvalid)
      User.count.should == (@num_users)
    end

    it "should not create user when created with no attributes" do
      @num_users = User.count
      user = User.create()
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
      user = User.create(FactoryGirl.attributes_for(:reg_user_min_create_attr).reject{|key,val| key == :password} )
      # user.should be_nil
      user.should be_instance_of(User)
      user.errors.count.should > 0
      User.count.should == (@num_users)
    end

    it "should not create user when created without password_confirmation" do
      @num_users = User.count
      user = User.create(FactoryGirl.attributes_for(:reg_user_min_create_attr).reject{|key,val| key == :password_confirmation} )
      # user.should be_nil
      user.should be_instance_of(User)
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
      user = User.create!(FactoryGirl.attributes_for(:user_create).merge(:first_name => FactoryGirl.attributes_for(:user_safe_attr)[:first_name]))
      User.count.should == (@num_users+1)
      @num_users = User.count
      user = User.create!(FactoryGirl.attributes_for(:user_create).merge(:last_name => FactoryGirl.attributes_for(:user_safe_attr)[:last_name]))
      User.count.should == (@num_users+1)
      @num_users = User.count
      user = User.create!(FactoryGirl.attributes_for(:user_create).merge(:username => FactoryGirl.attributes_for(:user_safe_attr)[:username]))
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
      user = User.create!(FactoryGirl.attributes_for(:user_create).merge(:first_name => FactoryGirl.attributes_for(:user_inval_attr)[:admin]))
      user.should_not respond_to(:admin)
      User.count.should == (@num_users+1)
      @num_users = User.count
      user = User.create!(FactoryGirl.attributes_for(:user_create).merge(:last_name => FactoryGirl.attributes_for(:user_inval_attr)[:foo]))
      user.should_not respond_to(:foo)
      User.count.should == (@num_users+1)
      @num_users = User.count
      user = User.create!(FactoryGirl.attributes_for(:user_create).merge(:username => FactoryGirl.attributes_for(:user_inval_attr)[:bar]))
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
      a_user = User.create(FactoryGirl.attributes_for(:user_create).merge(:email => 'test@controlledair.com') )
      User.count.should == @user_count+1
      @user_count = User.count
      a_user = User.create(FactoryGirl.attributes_for(:user_create).merge(:email => 'test@me.com') )
      User.count.should == @user_count+1
      @user_count = User.count
      a_user = User.create(FactoryGirl.attributes_for(:user_create).merge(:email => 'test@gmail.com') )
      User.count.should == @user_count+1
      @user_count = User.count
      a_user = User.create(FactoryGirl.attributes_for(:user_create).merge(:email => 'test@example.com') )
      User.count.should == @user_count+1
      @user_count = User.count
      a_user = User.create(FactoryGirl.attributes_for(:user_create).merge(:email => '1@me.com') )
      User.count.should == @user_count+1
    end
    it 'should reject invalid email addresses using VALID_EMAIL_EXPR application constant' do
      # %w{ test@testing.com a.b.com me@yahoo.com hello }.each do |email_addr|
      #   @user_count = User.count
      #   a_user = User.create!(FactoryGirl.attributes_for(:reg_user_min_create_attr).merge(:email => email_addr) )
      #   User.count.should == @user_count
      # end
      @user_count = User.count
      a_user = User.create(FactoryGirl.attributes_for(:user_create).merge(:email => 'test@testing.com') )
      User.count.should == @user_count
      a_user = User.create(FactoryGirl.attributes_for(:user_create).merge(:email => 'a.b.com') )
      User.count.should == @user_count
      a_user = User.create(FactoryGirl.attributes_for(:user_create).merge(:email => 'me@yahoo.com') )
      User.count.should == @user_count
      a_user = User.create(FactoryGirl.attributes_for(:user_create).merge(:email => 'hello') )
      User.count.should == @user_count
    end
    it 'should reject an email that is not unique' do
      @user_count = User.count
      user = User.create(FactoryGirl.attributes_for(:user_create).merge(:email => 'test@example.com') )
      # user.errors.each do |type, msg|
      #   msg.should == ''
      # end
      user.errors.count.should == 0
      User.count.should == @user_count+1
      @user_count = User.count
      user = User.create(FactoryGirl.attributes_for(:user_create).merge(:email => 'test@example.com') )
      user.errors.count.should > 0
      User.count.should == @user_count
    end
    it 'should reject a username is not unique' do
      @user_count = User.count
      user = User.create(FactoryGirl.attributes_for(:user_create).merge(:username => 'MyName') )
      user.errors.count.should == 0
      User.count.should == @user_count+1
      @user_count = User.count
      user = User.create(FactoryGirl.attributes_for(:user_create).merge(:username => 'MyName') )
      user.errors.count.should > 0
      User.count.should == @user_count
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


  context 'should properly test can_see_app?' do
    before(:each) do
      @reg = FactoryGirl.create(:reg_user_min_create_attr)
    end

    it 'should always see the see the system of the role, and not others' do
      # loop through all valid roles
      VALID_ROLES.each do |role|
        this_role = Role.new(role)
        # assign this role to this user
        @reg.update_attributes({:roles => role})
        @reg.has_role?(role).should be_true
        # Rails.logger.debug("T user_spec can_see_app? - role:#{role}, system:#{this_role.app_id}, #{@reg.can_see_app?(this_role.app_id)}")
        @reg.can_see_app?(this_role.app_id).should be_true
        # loop through all valid systems
        MENU_ITEMS.each do |app_id, app|
          # Rails.logger.debug("T user_spec can_see_app? check - role:#{role}, app:#{app_id}")
          appid = app_id.to_s
          # make sure it cannot see a (non default role) system different from its current (unless all system)
          if !DEFAULT_ROLES.split(' ').index(role).nil? && appid != this_role.app_id && this_role.app_id != 'all'
            # Rails.logger.debug("T user_spec can_see_app? - cant see others - role:#{role}, system:#{appid} - #{@reg.can_see_app?(appid)}")
            @reg.can_see_app?(appid).should be_false
          end
          # it system for this role is all, make sure it can see all systems
          if this_role.app_id == 'all'
            # Rails.logger.debug("T user_spec can_see_app? - all seeing all - role:#{role}, app:#{appid} - #{@reg.can_see_app?(appid)}")
            @reg.can_see_app?(appid).should be_true
          end
        end
      end
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
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  deactivated        :boolean
#

