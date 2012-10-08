require 'spec_helper'
include UserTestHelper
include ApplicationHelper


describe UsersController do

  context 'Role based authorization - systems access -  ' do
    it 'should limit access to systems by roles'
    it 'should have multiple subsystems allowed in the app_config'
  end
  
  context 'implement reset password code'do
    it 'should use email notifications of reset password'
    it 'should ensure that email addresses are sent and confirmed in user create'
  end
  context 'implement register user' do
    it 'should use email notifications of new user'
    it 'should ensure that email addresses are sent and confirmed in register user'
  end
  
end

