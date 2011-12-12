require 'spec_helper'
include UserTestHelper
include ApplicationHelper


describe UsersController do

  before(:each) do
    clear_session
  end
  
  context 'Role based authorization - systems access -  ' do
    it 'should limit access to systems by roles'
    it 'should have multiple subsystems allowed in the app_config'
  end
  
end
  
