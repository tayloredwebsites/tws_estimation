require 'spec_helper'
require 'capybara_spec_helper'

describe 'Layout Integration Tests - ' do

  companyName = APP_CONFIG['COMPANY_NAME']
  appName = APP_CONFIG['APP_NAME']
  homeIndexTitle = I18n.translate('home.index.title')
  homeIndexHeader = I18n.translate('home.index.header')

  context 'visit root_path/home_index/Home#index page - ' do
    before(:each) do
      visit home_index_path
    end
    it 'should find the title with exactly correct content' do		# capybara find
      find('title').text.should =~ /^#{companyName} - #{appName} - #{homeIndexTitle}$/
    end
    it 'should find exactly matching company name' do		# capybara find
      find('#header_tagline_company_name').text.should =~ /^#{companyName}$/
    end
    it 'should find exactly matching app name' do		# capybara find
      find('#header_tagline_app_name').text.should =~ /^#{appName}$/
    end
    it 'should not find all whitespace in the page title' do		# capybara find
      find('#header_tagline_page_title').text.should_not =~ /\A\s*\z/
    end
    it 'should find exactly matching page title from from app_config' do		# capybara find
      find('#header_tagline_page_title').text.should =~ /^#{homeIndexTitle}$/
    end
    it 'should not find all whitespace in the non-layout content' do		# capybara find
      find('div#content_body').text.should_not =~ /\A\s*\z/
    end
    it 'should have eMail in the upper left header' do
      find('div#header_logo_right').should have_content('eMail:')
    end
    it 'should have a help item in the top nav bar 6th item' do
      find('ul#header_nav_bar').find('li[6]/a').text.should =~ /\AHelp\z/
    end
    it 'should have Welcome in a left module header' do
      find('div.module_header', :text => 'Welcome')
    end
    it 'should have a help item somewhere in the left nav bar' do
      find('div#left_content').find('a', :text => 'Help')
    end
    it 'should have empty header notice' do
      find('div#content_header').find('p.notice').text.should =~ /\A\s*\z/
    end
    it 'should have an empty header alert' do
      find('div#content_header').find('p.alert').text.should =~ /\A\s*\z/
    end
    it 'should have an empty footer notice' do
      find('div#footer_status').find('p.notice').text.should =~ /\A\s*\z/
    end
    it 'should have an empty footer alert' do
      find('div#footer_status').find('p.alert').text.should =~ /\A\s*\z/
    end

  end

end
