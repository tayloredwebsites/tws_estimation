require 'spec_helper'
include UserTestHelper

require 'capybara_spec_helper'

describe 'Users Authorization Tests' do

  before(:each) do
    @user1 = User.create!(UserTestHelper.user_minimum_create_attributes)
  end

# it 'allow users to modify their password'
# it 'should allow an administrator to reset their password (and get it sent to email)'
# it 'should allow for users to be assigned roles'
# it 'should limit access to the application based upon the user roles'
# it 'should allow for the specification of the application for a particular role'
# 
# it 'should allow the users to edit their own information'
# it 'should allow the admins to edit their any user\'s information' 
# it 'should not allow deactivate unless signed in as admin'
# it 'should not allow reactivate unless signed in as admin'
# it 'should not allow delete unless signed in as admin, has been deactivated, and table ok for deletes without cleanup'
# it 'should allow the users to view their own information' # see users_controller_spec.rb
# it 'should not allow users to view other users information' # to do in users_controller_spec.rb
# it 'should allow users limited access to modify or delete their own information' # to do in users_controller_spec.rb

# 

end