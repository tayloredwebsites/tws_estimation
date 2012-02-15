# spec/models/user_roles_spec.rb
require 'spec_helper'
# include UserTestHelper

describe User do

  before(:each) do
    @admin_user = FactoryGirl.create(:admin_user_min_create_attr)
    @model = User.new
  end
  
  context 'User Role Based Authorization' do
    it 'should ensure that logged out users have the default role' do
      @user = User.guest
      if DEFAULT_ROLE.size > 0
        @user.roles.should_not == []
        @user.roles.should == DEFAULT_ROLE.join(' ')
        @user.assigned_roles.should == DEFAULT_ROLE
        @user.has_role?(DEFAULT_ROLE[0]).should be_true
      end
      @user.has_role?('xxx').should be_false
    end
    it 'should allow for users to be assigned roles from the VALID_ROLES app_constant' do
      @user = User.guest
      VALID_ROLES.each do |role|
        if DEFAULT_ROLE.index(role).nil?
          Rails.logger.debug("T user_roles_spec - role:#{role.to_s}")
          @user.has_role?(role).should be_false 
          Models::UserRoles.is_valid_role?(role).should be_true
          @user.add_role(role)
          @user.has_role?(role).should be_true
          @user.remove_role(role)
          @user.has_role?(role).should be_false
        end
      end
    end
    it 'should not allow for users to be assigned roles not in the VALID_ROLES app_constant' do
      @user = User.guest
      @user.add_role('xxx')
      @user.has_role?('xxx').should be_false
   end
    it 'should ensure that user assigned roles are preserved in the database' do
      @user = FactoryGirl.create(:user_min_create_attr)
      if DEFAULT_ROLE.size > 0
        @user.has_role?(DEFAULT_ROLE[0]).should be_true
      end
      @roles_count = @user.assigned_roles.size
      @user.assigned_roles.size.should == DEFAULT_ROLE.size
      if VALID_ROLES.size > 1
        @user.add_role(VALID_ROLES[1])
        @user.assigned_roles.size.should == @roles_count + 1
        @user.has_role?(VALID_ROLES[1]).should be_true
        @user.save
        @user.errors.count.should == 0
        @updated_user = User.find(@user.id)
        @updated_user.should_not be_nil
        @updated_user.should be_instance_of(User)
        @updated_user.errors.count.should == 0
        @updated_user.roles.should_not be_nil
        @updated_user.assigned_roles.should_not be_nil
        @updated_user.has_role?(VALID_ROLES[1]).should be_true
        @updated_user.assigned_roles.size.should == @roles_count + 1
      end
      if DEFAULT_ROLE.size > 0
        @updated_user.has_role?(DEFAULT_ROLE[0]).should be_true
      end
    end
    it 'should have which subsystems are specified in each role' do
      # test this in controller and/or integration testing
    end
    it 'should allow admin users to assign a user to an subsystem role' do
      # test this in controller and/or integration testing
    end
    it 'should limit access to each subsystem based upon the user roles' do
      # test this in controller and/or integration testing
    end
    it 'should have multiple subsystems allowed in the app_config' do
      # test this in controller and/or integration testing
    end
  end

end
