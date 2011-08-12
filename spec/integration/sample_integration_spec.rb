require 'spec_helper'
require 'capybara_spec_helper'

describe 'Sample Home Integration Tests - ' do

  appName = APP_CONFIG['APP_NAME']
  companyName = APP_CONFIG['COMPANY_NAME']
  
  context 'visit home_index page - ' do
  
    pageTitle = I18n.translate('home.index.title')
    pageHeader = I18n.translate('home.index.header')
    
    before(:each) do
      visit home_index_path
    end
    it 'should match an h4 tag' do
      body.should =~ /(.)*\<h4>(.)*<\/h4>(.)*/
    end
    it 'should find the exact content to match an h4 tag' do    # capybara find
      find('div#content_body').find('h4').text.should =~ /^#{pageHeader}$/
    end
    #it 'should find the content from the home help page' do    # capybara find
    #  find('h4').should have_content(the_controller_name)    # controller not found here, but works in integration tests
    #end
    it 'should find a span tag with class label with value "To Do"' do    # capybara find
      find('div#content_body').find('span.label[1]').should have_content('To Do')
    end
    it 'should find via xpath content in the title' do    # capybara find
      find(:xpath, '//div[@id="content_body"]//span[@class="label"][1]').text.should =~ /^To Do$/  # match (a line) first occurrance of a span with class of label
    end
    it 'should match a span tag with class label with the exact value' do    # capybara find
      find('div#content_body').find('div.field[1]/span.label').text.should =~ /\ATo Do\z/  # match entire string
    end
    it 'should match a span tag with class value with the exact value' do    # capybara find
      find('div#content_body').find('div.field[1]/span.value').text.should =~ /\AUpdate me in app\/views\/home\/index.html.erb\z/
    end

  end

  context 'visit home_help page - ' do

    pageTitle = I18n.translate('home.help.title')
    pageHeader = I18n.translate('home.help.header')
    # the_controller_name = controller.controller_name.capitalize  # error - controller not found here, but works in integration tests

    before(:each) do
      visit home_help_path
    end
    it 'should match an h4 tag' do
      body.should =~ /(.)*\<h4>(.)*<\/h4>(.)*/
    end
    it 'should find the exact content to match an h4 tag' do    # capybara find
      find('div#content_body').find('h4').text.should =~ /^#{pageHeader}$/
    end
    #it 'should find the content from the home help page' do    # capybara find
    #  find('h4').should have_content(the_controller_name)    # controller not found here, but works in integration tests
    #end
    it 'should find a span tag with class label with value "To Do"' do    # capybara find
      find('div#content_body').find('span.label[1]').should have_content('To Do')
    end
    it 'should find via xpath content in the title' do    # capybara find
      find(:xpath, '//div[@id="content_body"]//span[@class="label"][1]').text.should =~ /^To Do$/  # match (a line) first occurrance of a span with class of label
    end
    it 'should match a span tag with class label with the exact value' do    # capybara find
      find('div#content_body').find('div.field[1]/span.label').text.should =~ /\ATo Do\z/  # match entire string
    end
    it 'should match a span tag with class value with the exact value' do    # capybara find
      find('div#content_body').find('div.field[1]/span.value').text.should =~ /\AUpdate me in app\/views\/home\/help.html.erb\z/
    end

  end

  context 'visit home_status page - ' do
  
    pageTitle = I18n.translate('home.status.title')
    pageHeader = I18n.translate('home.status.header')
    
    before(:each) do
      visit home_status_path
    end
    it 'should match an h4 tag' do
      body.should =~ /(.)*\<h4>(.)*<\/h4>(.)*/
    end
    it 'should find the content from the home status page' do    # capybara find
      find('div#content_body').find('h4').text.should =~ /^#{pageHeader}$/
    end
    it 'should match a span tag with class label with value "APP_NAME"' do    # capybara find
      find('div#content_body').find('div.field[3]/span.label').should have_content('APP_NAME')
    end
    it 'should match a span tag with class label with the value of APP_NAME' do    # capybara find
      find('div#content_body').find('div.field[3]/span.value').should have_content("#{appName}")
    end
    it 'should find via xpath a span tag with class label with the exact value "APP_NAME"' do    # capybara find
      find('div#content_body').find(:xpath, '//div[@class="field"][3]/span[@class="label"]').text.should =~ /\AAPP_NAME\z/
    end
    it 'should find via xpath a span tag with class label with the value of "APP_NAME"' do    # capybara find
      find('div#content_body').find(:xpath, '//div[@class="field"][3]/span[@class="value"]').text.should =~ /\A#{appName}\z/
    end

  end

end
