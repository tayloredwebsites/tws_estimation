require 'spec_helper'
require 'capybara_spec_helper'

describe 'Integration Tests To Do- ' do

	companyName = APP_CONFIG['COMPANY_NAME']
	appName = APP_CONFIG['APP_NAME']
	homeIndexTitle = I18n.translate('home.index.title')
	homeIndexHeader = I18n.translate('home.index.header')

	context 'visit root_path/home_index/Home#index page - ' do
		before(:each) do
			visit home_index_path
		end
		it 'should have app_config in ruby hash'
		it 'should have app_config internationalized'
		it 'should have an internationalization application helper'
		it 'should be html5 with graceful degredations'
		it 'should have user authentication'
		it 'should have role based authorization'
		it 'should have application specified in roles'
		it 'should have multiple applications allowed in the app_config'
		it 'should save page scope for page layout internationalization'
		
	end

end
