require 'spec_helper'
include UserIntegrationHelper

describe 'Home Integration Tests - ' do

  appName = I18n.translate('app_name')
  companyName = I18n.translate('company_name')

  context 'visit home_index page - ' do
    
    pageTitle = I18n.translate('home.index.title')
    pageHeader = I18n.translate('home.index.header')
        
    before(:each) do
      visit home_index_path
    end
    it 'should find the content from the home index page' do        # capybara find
      find('h4').text.should =~ /^#{pageHeader}$/
    end
    #it 'should find the content from the home help page' do        # capybara find
    #  find('h4').should have_content('Home#help')
    #end
    it 'should match a span tag with class label with the exact value' do        # capybara find
      find('div#content_body').find('div.field[1]/span.label').text.should =~ /\ATo Do\z/
    end
    it 'should match a span tag with class value with the exact value' do        # capybara find
      find('div#content_body').find('div.field[1]/span.value').text.should =~ /\AUpdate me in app\/views\/home\/index.html.erb\z/
    end

  end

  context 'visit Home Contact page - ' do

    pageTitle = I18n.translate('home.contact.title')
    pageHeader = I18n.translate('home.contact.header')

    before(:each) do
      visit home_contact_path
    end
    it 'should find the exact content to match an h4 tag' do        # capybara find
      find('div#content_body').find('h4').text.should =~ /^#{pageHeader}$/
    end
    #it 'should find the content from the home help page' do        # capybara find
    #  find('h4').should have_content('Home#help')
    #end
    it 'should match a span tag with class label with the exact value' do        # capybara find
      find('div#content_body').find('div.field[1]/span.label').text.should =~ /\ATo Do\z/
    end
    it 'should match a span tag with class value with the exact value' do        # capybara find
      find('div#content_body').find('div.field[1]/span.value').text.should =~ /\AUpdate me in app\/views\/home\/contact.html.erb\z/
    end

  end

  context 'visit Home Help page - ' do

    pageTitle = I18n.translate('home.help.title')
    pageHeader = I18n.translate('home.help.header')

    before(:each) do
      visit home_help_path
    end
    it 'should find the exact content to match an h4 tag' do        # capybara find
      find('div#content_body').find('h4').text.should =~ /^#{pageHeader}$/
    end
    #it 'should find the content from the home help page' do        # capybara find
    #  find('h4').should have_content('Home#help')
    #end
    it 'should match a span tag with class label with the exact value' do        # capybara find
      find('div#content_body').find('div.field[1]/span.label').text.should =~ /\ATo Do\z/
    end
    it 'should match a span tag with class value with the exact value' do        # capybara find
      find('div#content_body').find('div.field[1]/span.value').text.should =~ /\AUpdate me in app\/views\/home\/help.html.erb\z/
    end

  end

  context 'visit Home News page - ' do

    pageTitle = I18n.translate('home.news.title')
    pageHeader = I18n.translate('home.news.header')

    before(:each) do
      visit home_news_path
    end
    it 'should find the exact content to match an h4 tag' do        # capybara find
      find('div#content_body').find('h4').text.should =~ /^#{pageHeader}$/
    end
    #it 'should find the content from the home help page' do        # capybara find
    #  find('h4').should have_content('Home#help')
    #end
    it 'should match a span tag with class label with the exact value' do        # capybara find
      find('div#content_body').find('div.field[1]/span.label').text.should =~ /\ATo Do\z/
    end
    it 'should match a span tag with class value with the exact value' do        # capybara find
      find('div#content_body').find('div.field[1]/span.value').text.should =~ /\AUpdate me in app\/views\/home\/news.html.erb\z/
    end

  end

  context 'visit Home Site Map page - ' do

    pageTitle = I18n.translate('home.site_map.title')
    pageHeader = I18n.translate('home.site_map.header')
    
    context 'logged in user' do

      before(:each) do
      end
      
      it 'should go to the site_map page' do        # capybara find
        @user1 = FactoryGirl.create(:user_min_create_attr)
        @model = User.new
        helper_signin(:user_min_create_attr, @user1.full_name)
        visit home_site_map_path
        #save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.site_map.header')}$/
        find('div#content_body').find('div.field[1]/span.label').text.should =~ /\ATo Do\z/
        find('div#content_body').find('div.field[1]/span.value').text.should =~ /\AUpdate me in app\/views\/home\/site_map.html.erb\z/
      end
      
    end

  end

  context 'visit Home Status page - ' do
    
    pageTitle = I18n.translate('home.status.title')
    pageHeader = I18n.translate('home.status.header')
        
    before(:each) do
      visit home_status_path
    end
    it 'should find the content from the home index page' do        # capybara find
      find('h4').text.should =~ /^#{pageHeader}$/
    end
    it 'should match a span tag with class label with value "APP_NAME"' do        # capybara find
      find('div#content_body').find('div.field[2]/span.label').text.should =~ /\AAPP_NAME\z/
    end
    it 'should match a span tag with class label with the value of APP_NAME' do        # capybara find
      find('div#content_body').find('div.field[2]/span.value').text.should =~ /\A#{appName}\z/
    end
    it 'should find via xpath a span tag with class label with the exact value "APP_NAME"' do    # capybara find
      find(:xpath, '//div[@id="content_body"]//div[@class="field"][2]/span[@class="label"]').text.should =~ /\AAPP_NAME\z/
    end
    it 'should find via xpath a span tag with class label with the value of "APP_NAME"' do    # capybara find
      find(:xpath, '//div[@id="content_body"]//div[@class="field"][2]/span[@class="value"]').text.should =~ /\A#{appName}\z/
    end

  end

end
