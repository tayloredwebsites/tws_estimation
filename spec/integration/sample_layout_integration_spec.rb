require 'spec_helper'
require 'capybara_spec_helper'

describe 'Sample Layout Integration Tests - ' do

	companyName = APP_CONFIG['COMPANY_NAME']
	appName = APP_CONFIG['APP_NAME']
	homeIndexTitle = I18n.translate('home.index.title')
	homeIndexHeader = I18n.translate('home.index.header')

	context 'visit root_path/home_index/Home#index page - ' do
		before(:each) do
			visit home_index_path
		end
		it 'should not find all whitespace in the title' do
			find('title').text.should_not =~ /\A\s*\z/
		end
    it 'should find the title with correct content' do		# capybara find
      find('title').should have_content(companyName+' - '+appName+' - '+homeIndexTitle)
    end
		it 'should find the title with exactly correct content' do		# capybara find
			find('title').text.should =~ /^#{companyName} - #{appName} - #{homeIndexTitle}$/
		end
		it 'should find the title via xpath with exactly correct content' do		# capybara find
			find(:xpath, '//title').text.should =~ /^#{companyName} - #{appName} - #{homeIndexTitle}$/
		end
		it 'should not find all whitespace in the company name' do		# capybara find
			find('#header_tagline_company_name').text.should_not =~ /\A\s*\z/
		end
		it 'should find company name' do		# capybara find
			find('#header_tagline_company_name').should have_content(companyName)
		end
		it 'should find exactly matching company name' do		# capybara find
			find('#header_tagline_company_name').text.should =~ /^#{companyName}$/
		end
		it 'should find via xpath exactly matching company name' do		# capybara find
			find(:xpath, '//*[@id="header_tagline_company_name"]').text.should =~ /^#{companyName}$/
		end
		it 'should not find all whitespace in the app name' do		# capybara find
			find('#header_tagline_app_name').text.should_not =~ /\A\s*\z/
		end
		it 'should find app name' do		# capybara find
			find('#header_tagline_app_name').should have_content(appName)
		end
		it 'should find exactly matching app name' do		# capybara find
			find('#header_tagline_app_name').text.should =~ /^#{appName}$/
		end
		it 'should find via xpath  exactly matching app name' do		# capybara find
			find(:xpath, '//*[@id="header_tagline_app_name"]').text.should =~ /^#{appName}$/
		end
		it 'should not find all whitespace in the page title' do		# capybara find
			find('#header_tagline_page_title').text.should_not =~ /\A\s*\z/
		end
		it 'should find page title from from app_config' do		# capybara find
			find('#header_tagline_page_title').should have_content(homeIndexTitle)
		end
		it 'should find matching page title from from app_config' do		# capybara find
			find('#header_tagline_page_title').text.should =~ /(.)*#{homeIndexTitle}(.)*/
		end
		it 'should find exactly matching page title from from app_config' do		# capybara find
			find('#header_tagline_page_title').text.should =~ /^#{homeIndexTitle}$/
		end
		it 'should not find all whitespace in the non-layout content' do		# capybara find
			find('div#content_body').text.should_not =~ /\A\s*\z/
		end
		
	end

end
