require 'spec_helper'
# require 'capybara_spec_helper'

describe "Page Existing tests" do

  it 'should be able to visit home_index page' do
    visit home_index_path
    current_path.should == home_index_path
    find('#header_tagline_page_header').text.should_not =~ /\A\s*\z/
    find('#header_tagline_page_header').text.should_not =~ /translation missing/
    find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.index.header')}$/
  end
  it 'should be able to visit home_help page' do
    visit home_help_path
    current_path.should == home_help_path
    find('#header_tagline_page_header').text.should_not =~ /\A\s*\z/
    find('#header_tagline_page_header').text.should_not =~ /translation missing/
    find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.help.header')}$/
  end
  it 'should be able to visit home_about page' do
    visit home_about_path
    current_path.should == home_about_path
    find('#header_tagline_page_header').text.should_not =~ /\A\s*\z/
    find('#header_tagline_page_header').text.should_not =~ /translation missing/
    find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.about.header')}$/
  end
  it 'should be able to visit home_contact page' do
    visit home_contact_path
    find('#header_tagline_page_header').text.should_not =~ /\A\s*\z/
    find('#header_tagline_page_header').text.should_not =~ /translation missing/
    find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.contact.header')}$/
  end
  it 'should be able to visit home_news page' do
    visit home_news_path
    find('#header_tagline_page_header').text.should_not =~ /\A\s*\z/
    find('#header_tagline_page_header').text.should_not =~ /translation missing/
    find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.news.header')}$/
  end
  # see spec/integration/users_authentication_spec.rb for signed in tests
  it 'should not be able to visit home_site_map page (goes to signin page)' do
    visit home_site_map_path
    find('#header_tagline_page_header').text.should_not =~ /\A\s*\z/
    find('#header_tagline_page_header').text.should_not =~ /translation missing/
    find('#header_tagline_page_header').text.should_not =~ /^#{I18n.translate('home.site_map.header')}$/
  end
  it 'should be able to visit home_status page' do
    visit home_status_path
    find('#header_tagline_page_header').text.should_not =~ /\A\s*\z/
    find('#header_tagline_page_header').text.should_not =~ /translation missing/
    find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.status.header')}$/
  end
  it 'should be able to visit home_errors page' do
    visit home_errors_path
    find('#header_tagline_page_header').text.should_not =~ /\A\s*\z/
    find('#header_tagline_page_header').text.should_not =~ /translation missing/
    find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.errors.header')}$/
  end

end
