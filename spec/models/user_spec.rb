# spec/models/user_spec.rb
require 'spec_helper'
include UserTestHelper

describe User do

  before(:each) do
    @user1 = User.create!(UserTestHelper.user_minimum_attributes)
    @model = User.new
  end
  
  it 'deactivate method should deactivate an active user' do
    #confirm the user is not deactivated
    @user1.deactivated.should be_false
    # deactivate user
    @user1.deactivate
    #confirm no errors were generated
    @user1.errors.count.should be == 0
    # refresh the user from the database
    @updated_user = User.find(@user1.id)
    #confirm the user has been deactivated
    @updated_user.deactivated.should be_true
  end

  it 'reactivate method should reactivate a deactivated user' do
    #confirm the user is not deactivated
    @user1.deactivated.should be_false
    # deactivate user
    @user1.deactivate
    # refresh the user from the database
    @updated_user = User.find(@user1.id)
    #confirm the user has been deactivated
    @updated_user.deactivated.should be_true
    # reactivate user
    @user1.reactivate
    #confirm no errors were generated
    @user1.errors.count.should be == 0
    # refresh the user from the database
    @updated_user = User.find(@user1.id)
    #confirm the user has been reactivated
    @updated_user.deactivated.should be_false
  end

  it 'reactivate method should not reactivate an active user' do
    #confirm the user is not deactivated
    @user1.deactivated.should be_false
    # reactivate user
    @user1.reactivate
    #confirm errors were generated
    @user1.errors.count.should be > 0
    # confirm got an error on the deactivated field
    @user1.errors[:deactivated].should == ["#{I18n.translate('error_messages.is_active')}"]
    # refresh the user from the database
    @updated_user = User.find(@user1.id)
    #confirm the user is still not deactivated
    @updated_user.deactivated.should be_false
  end

  it 'deactivate method should not deactivate a deactivated user' do
    #confirm the user is not deactivated
    @user1.deactivated.should be_false
    # deactivate user
    @user1.deactivate
    # refresh the user from the database
    @updated_user = User.find(@user1.id)
    #confirm the user has been deactivated
    @updated_user.deactivated.should be_true
    # deactivate user
    @user1.deactivate
    #confirm errors were generated
    @user1.errors.count.should be > 0
    # confirm got an error on the deactivated field
    @user1.errors[:deactivated].should == ["#{I18n.translate('error_messages.is_deactivated')}"]
    # confirm got a :base error
    @user1.errors[:base].should == ["#{I18n.translate('errors.cannot_method_msg', :method => 'deactivate', :msg => I18n.translate('error_messages.is_deactivated') )}"]
    # refresh the user from the database
    @updated_user = User.find(@user1.id)
    #confirm the user is still deactivated
    @updated_user.deactivated.should be_true
  end

  it 'destroy should not destroy an active user' do
    #confirm the user is active
    @user1.deactivated.should be_false
    # save the user id
    @user_id = @user1.id
    # destroy user
    @user1.destroy
    #confirm errors were generated
    @user1.errors.count.should be > 0
    # confirm got an error on the deactivated field
    @user1.errors[:deactivated].should == ["#{I18n.translate('error_messages.is_active')}"]
    # confirm got a :base error
    @user1.errors[:base].should == ["#{I18n.translate('errors.cannot_method_msg', :method => 'destroy', :msg => I18n.translate('error_messages.is_active') )}"]
    # refresh the user from the database
    @updated_user = User.find(@user_id)
    #confirm the user has been deactivated
    @updated_user.should_not be_nil
    #confirm the user still active
    @updated_user.deactivated.should be_false
  end
  
  it 'destroy should destroy a deactivated user' do
    #confirm the user is active
    @user1.deactivated.should be_false
    # deactivate user
    @user1.deactivate
    # refresh the user from the database
    @updated_user = User.find(@user1.id)
    #confirm the user has been deactivated
    @updated_user.deactivated.should be_true
    # save the user id
    @user_id = @user1.id
    # destroy user
    @user1.destroy
    #confirm no errors were generated
    @user1.errors.count.should be == 0
    # confirm the user is not in the database
    lambda {User.find(@user_id)}.should raise_error(ActiveRecord::RecordNotFound)
    # # refresh the user from the database
    # @updated_user = User.find(@user_id)
    # #confirm the user has been deactivated
    # @updated_user.should be_nil
  end
  
  it 'delete should not delete an active user' do
    #confirm the user is active
    @user1.deactivated.should be_false
    # save the user id
    @user_id = @user1.id
    # deactivate user
    @user1.delete
    #confirm errors were generated
    @user1.errors.count.should be > 0
    # confirm got a :base error
    @user1.errors[:base].should == ["#{I18n.translate('errors.cannot_method_msg', :method => 'delete', :msg => I18n.translate('error_messages.is_active') )}"]
    # confirm got an error on the deactivated field
    @user1.errors[:deactivated].should == ["#{I18n.translate('error_messages.is_active')}"]
    # refresh the user from the database
    @updated_user = User.find(@user_id)
    #confirm the user has been deactivated
    @updated_user.should_not be_nil
    #confirm the user still active
    @updated_user.deactivated.should be_false
  end
  
  it 'delete should delete a deactivated user' do
    #confirm the user is active
    @user1.deactivated.should be_false
    # deactivate user
    @user1.deactivate
    # refresh the user from the database
    @updated_user = User.find(@user1.id)
    #confirm the user has been deactivated
    @updated_user.deactivated.should be_true
    # save the user id
    @user_id = @user1.id
    # delete user
    @user1.delete
    #confirm no errors were generated
    @user1.errors.count.should be == 0
    # confirm the user is not in the database
    lambda {User.find(@user_id)}.should raise_error(ActiveRecord::RecordNotFound)
    # # refresh the user from the database
    # @updated_user = User.find(@user_id)
    # #confirm the user has been deactivated
    # @updated_user.should be_nil
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

