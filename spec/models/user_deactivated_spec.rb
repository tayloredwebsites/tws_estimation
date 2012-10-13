# spec/models/user_spec.rb
require 'spec_helper'
# include UserTestHelper

describe User do

  context 'Model deactivated tests - ' do
    
    before(:each) do
      @user1 = FactoryGirl.create(:admin_user_min_create_attr)
      @model = User.new
    end
  
    it 'deactivate method should deactivate an active user' do
      @user1.deactivated?.should be_false
      @user1.deactivate
      @user1.errors.count.should == 0
      @user1.errors.count.should be == 0
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_true
    end

    it 'reactivate method should reactivate a deactivated user' do
      @user1.deactivated?.should be_false
      @user1.deactivate
      @user1.errors.count.should == 0
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_true
      @user1.reactivate
      @user1.errors.count.should be == 0
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_false
    end

    it 'reactivate method should not reactivate an active user' do
      @user1.deactivated?.should be_false
      @user1.reactivate
      @user1.errors.count.should be > 0
      @user1.errors[:deactivated].should == ["#{I18n.translate('error_messages.is_active')}"]
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_false
    end

    it 'deactivate method should not deactivate a deactivated user' do
      @user1.deactivated?.should be_false
      @user1.deactivate
      @user1.errors.count.should == 0
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_true
      @user1.deactivate
      @user1.errors.count.should be > 0
      @user1.errors[:deactivated].should == ["#{I18n.translate('error_messages.is_deactivated')}"]
      @user1.errors[:base].should == ["#{I18n.translate('errors.cannot_method_msg', :method => 'deactivate', :msg => I18n.translate('error_messages.is_deactivated') )}"]
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_true
    end

    it 'destroy should not destroy an active user' do
      @user1.deactivated?.should be_false
      @user_id = @user1.id
      @user1.destroy
      @user1.errors.count.should be > 0
      @user1.errors[:deactivated].should == ["#{I18n.translate('error_messages.is_active')}"]
      @user1.errors[:base].should == ["#{I18n.translate('errors.cannot_method_msg', :method => 'destroy', :msg => I18n.translate('error_messages.is_active') )}"]
      @updated_user = User.find(@user_id)
      @updated_user.should_not be_nil
      @updated_user.deactivated?.should be_false
    end
  
    it 'destroy should destroy a deactivated user' do
      @user1.deactivated?.should be_false
      @user1.deactivate
      @user1.errors.count.should == 0
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_true
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
      @user1.deactivated?.should be_false
      @user_id = @user1.id
      @user1.delete
      @user1.errors.count.should be > 0
      @user1.errors[:base].should == ["#{I18n.translate('errors.cannot_method_msg', :method => 'delete', :msg => I18n.translate('error_messages.is_active') )}"]
      @user1.errors[:deactivated].should == ["#{I18n.translate('error_messages.is_active')}"]
      @updated_user = User.find(@user_id)
      @updated_user.should_not be_nil
      @updated_user.deactivated?.should be_false
    end
  
    it 'delete should delete a deactivated user' do
      @user1.deactivated?.should be_false
      @user1.deactivate
      @user1.errors.count.should be == 0
      @updated_user = User.find(@user1.id)
      @updated_user.deactivated?.should be_true
      @user_id = @user1.id
      @user1.delete
      @user1.errors.count.should be == 0
      lambda {User.find(@user_id)}.should raise_error(ActiveRecord::RecordNotFound)
      # # refresh the user from the database
      # @updated_user = User.find(@user_id)
      # #confirm the user has been deactivated
      # @updated_user.should be_nil
    end
  
    it 'should have deactivated set to DB_FALSE or DB_TRUE (during create, ... see logger.debug)' do
      @user1.deactivated?.should be_false
      # boolean field in model (not the database data type)
      # @user1.deactivated.should == DB_FALSE
      @user1.deactivated.should == false
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

