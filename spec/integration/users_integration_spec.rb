require 'spec_helper'
require 'capybara_spec_helper'

describe 'Users Integration Tests - ' do

  appName = APP_CONFIG['APP_NAME']
  companyName = APP_CONFIG['COMPANY_NAME']
  
  context 'should confirm routing is correct' # see http://edgeguides.rubyonrails.org/routing.html
      #'assert_routing({ :path => "photos", :method => :post }, { :controller => "photos", :action => "create" })
  context 'should allow the users to view their own information'
  context 'should allow the users to edit their own information'
  context 'should temporarily allow the users to be created without security'
  context 'should temporarily allow the users to be deactivated without security'
  context 'should temporarily allow the users to be reactivated without security'
  context 'should temporarily allow the users to be deleted (only if deactivated) without security'
  context 'visit home_xxx page'

end
