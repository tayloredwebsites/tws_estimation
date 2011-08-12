require 'spec_helper'
require 'capybara_spec_helper'

describe 'Home Integration Tests - ' do

  companyName = APP_CONFIG['COMPANY_NAME']
  appName = APP_CONFIG['APP_NAME']

  context 'visit home_index page - ' do
	
    pageTitle = I18n.translate('home.index.title')
    pageHeader = I18n.translate('home.index.header')
		
    before(:each) do
      visit home_index_path
    end
    it 'should find the content from the home index page' do		# capybara find
      find('h4').text.should =~ /^#{pageHeader}$/
    end
    #it 'should find the content from the home help page' do		# capybara find
    #  find('h4').should have_content('Home#help')
    #end
    it 'should match a span tag with class label with the exact value' do		# capybara find
      find('div#content_body').find('div.field[1]/span.label').text.should =~ /\ATo Do\z/
    end
    it 'should match a span tag with class value with the exact value' do		# capybara find
      find('div#content_body').find('div.field[1]/span.value').text.should =~ /\AUpdate me in app\/views\/home\/index.html.erb\z/
    end

  end

  context 'visit Home Contact page - ' do

    pageTitle = I18n.translate('home.contact.title')
    pageHeader = I18n.translate('home.contact.header')

    before(:each) do
      visit home_contact_path
    end
    it 'should find the exact content to match an h4 tag' do		# capybara find
      find('div#content_body').find('h4').text.should =~ /^#{pageHeader}$/
    end
    #it 'should find the content from the home help page' do		# capybara find
    #  find('h4').should have_content('Home#help')
    #end
    it 'should match a span tag with class label with the exact value' do		# capybara find
      find('div#content_body').find('div.field[1]/span.label').text.should =~ /\ATo Do\z/
    end
    it 'should match a span tag with class value with the exact value' do		# capybara find
      find('div#content_body').find('div.field[1]/span.value').text.should =~ /\AUpdate me in app\/views\/home\/contact.html.erb\z/
    end

  end

  context 'visit Home Help page - ' do

    pageTitle = I18n.translate('home.help.title')
    pageHeader = I18n.translate('home.help.header')

    before(:each) do
      visit home_help_path
    end
    it 'should find the exact content to match an h4 tag' do		# capybara find
      find('div#content_body').find('h4').text.should =~ /^#{pageHeader}$/
    end
    #it 'should find the content from the home help page' do		# capybara find
    #  find('h4').should have_content('Home#help')
    #end
    it 'should match a span tag with class label with the exact value' do		# capybara find
      find('div#content_body').find('div.field[1]/span.label').text.should =~ /\ATo Do\z/
    end
    it 'should match a span tag with class value with the exact value' do		# capybara find
      find('div#content_body').find('div.field[1]/span.value').text.should =~ /\AUpdate me in app\/views\/home\/help.html.erb\z/
    end

  end

  context 'visit Home News page - ' do

    pageTitle = I18n.translate('home.news.title')
    pageHeader = I18n.translate('home.news.header')

    before(:each) do
      visit home_news_path
    end
    it 'should find the exact content to match an h4 tag' do		# capybara find
      find('div#content_body').find('h4').text.should =~ /^#{pageHeader}$/
    end
    #it 'should find the content from the home help page' do		# capybara find
    #  find('h4').should have_content('Home#help')
    #end
    it 'should match a span tag with class label with the exact value' do		# capybara find
      find('div#content_body').find('div.field[1]/span.label').text.should =~ /\ATo Do\z/
    end
    it 'should match a span tag with class value with the exact value' do		# capybara find
      find('div#content_body').find('div.field[1]/span.value').text.should =~ /\AUpdate me in app\/views\/home\/news.html.erb\z/
    end

  end

  context 'visit Home Site Map page - ' do

    pageTitle = I18n.translate('home.site_map.title')
    pageHeader = I18n.translate('home.site_map.header')

    before(:each) do
      visit home_site_map_path
    end
    it 'should find the exact content to match an h4 tag' do		# capybara find
      find('div#content_body').find('h4').text.should =~ /^#{pageHeader}$/
    end
    #it 'should find the content from the home help page' do		# capybara find
    #  find('h4').should have_content('Home#help')
    #end
    it 'should match a span tag with class label with the exact value' do		# capybara find
      find('div#content_body').find('div.field[1]/span.label').text.should =~ /\ATo Do\z/
    end
    it 'should match a span tag with class value with the exact value' do		# capybara find
      find('div#content_body').find('div.field[1]/span.value').text.should =~ /\AUpdate me in app\/views\/home\/site_map.html.erb\z/
    end

  end

  context 'visit Home Status page - ' do
	
    pageTitle = I18n.translate('home.status.title')
    pageHeader = I18n.translate('home.status.header')
		
    before(:each) do
      visit home_status_path
    end
    it 'should find the content from the home index page' do		# capybara find
      find('h4').text.should =~ /^#{pageHeader}$/
    end
    it 'should match a span tag with class label with value "APP_NAME"' do		# capybara find
      find('div#content_body').find('div.field[3]/span.label').text.should =~ /\AAPP_NAME\z/
    end
    it 'should match a span tag with class label with the value of APP_NAME' do		# capybara find
      find('div#content_body').find('div.field[3]/span.value').text.should =~ /\A#{appName}\z/
    end

  end

end
