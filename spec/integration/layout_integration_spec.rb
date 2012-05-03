# layout_integration_spec.rb

require 'spec_helper'
include UserIntegrationHelper
include ApplicationHelper

describe 'Users layouts Tests - ' do

  context ' - Layout (common to all users) - ' do
    before(:each) do
      visit home_index_path
    end
    it 'should find the title with exactly correct content' do        # capybara find
      find('title').text.should =~ /^#{I18n.translate('config.company_name')} - #{I18n.translate('config.app_name')} - #{I18n.translate('home.index.title')}$/
    end
    # it 'should find exactly matching company name' do        # capybara find
    #   find('#header_tagline_company_name').text.should =~ /^#{I18n.translate('config.company_name')}$/
    # end
    it 'should find exactly matching app name' do        # capybara find
      find('#header_tagline_app_name').text.should =~ /^#{I18n.translate('config.app_name')}$/
    end
    it 'should not find all whitespace in the System title' do
      find('#header_tagline_system_header').text.should_not =~ /\A\s*\z/
    end
    it 'should find exactly matching System title' do
      find('#header_tagline_system_header').text.should =~ /^#{I18n.translate('applications.guest.full_name')}$/
    end
    it 'should not find all whitespace in the page title' do
      find('#header_tagline_page_header').text.should_not =~ /\A\s*\z/
    end
    it 'should find exactly matching page title' do
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.index.header')}$/
    end
    it 'should not find all whitespace in the non-layout content' do
      find('div#content_body').text.should_not =~ /\A\s*\z/
    end
    it 'should have eMail in the upper left header' do
      find('div#header_logo_right').should have_content(I18n.translate('view_labels.email'))
    end
    it 'should have a help item in the top nav bar' do
      page.should have_selector('ul#header_nav_bar//a', :text => I18n.translate('home.help.title') )
    end
    it 'should have an about item in the top nav bar' do
      page.should have_selector('ul#header_nav_bar//a', :text => I18n.translate('home.about.title') )
    end
    it 'should not have Welcome in a left module header' do
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]').text.should_not =~
        /#{I18n.translate('view_labels.welcome_user', :user => '') }/
    end
    it 'should have a signin link in a left module header' do
      find('div.module_header/a', :text => I18n.translate('users_sessions.signin.title'))
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]/a').text.should =~
        /^#{I18n.translate('users_sessions.signin.title') }$/
    end
    it 'should have a reset password link in a left module header' do
      find(:xpath, '//div[@id="left_content"]/div/div[@class="module_header"]/a').text.should =~
        /#{I18n.translate('users_sessions.signin.action')}/
    end
    it 'should have a help link in the left nav bar' do
      find('div#left_content').find('a', :text => I18n.translate('home.help.title'))
    end
    it 'should have empty header notice' do
      find('div#header_status').find('p.notice').text.should =~ /\A\s*\z/
    end
    it 'should have an empty footer notice' do
      find('div#footer_status').find('p.notice').text.should =~ /\A\s*\z/
    end
    it 'should have an empty footer alert' do
      find('div#footer_status').find('p.alert').text.should =~ /\A\s*\z/
    end
    it "should start at the Home page" do
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.index.header')}$/
    end
    it 'should go to help page when top nav help link is clicked' do
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.index.header')}$/
      find('ul#header_nav_bar').find('a', :text => I18n.translate('home.help.title')).click
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.help.header')}$/
    end
    it 'should go to help page when left nav help link is clicked' do
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.index.header')}$/
      find('div#left_content').find('a', :text => I18n.translate('home.help.title')).click
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.help.header')}$/
    end
    it 'should go to the home page when the logo is clicked' do
      # first go to help page
      find('ul#header_nav_bar').find('a', :text => I18n.translate('home.help.title')).click
      # confirm at help page
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.help.header')}$/
      # click on logo
      find(:xpath, "//img[@alt=\"#{I18n.translate('home.index.title')}\"]/parent::a").click
      # confirm at home page
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.index.header')}$/
    end
    it 'should go to the About page when the footer about link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.about.title')).click
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.about.header')}$/
    end        
    it 'should go to the License page when the footer License link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.license.title')).click
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.license.header')}$/
    end        
    it 'should go to the Contact page when the footer contact link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.contact.title')).click
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.contact.header')}$/
    end    
    it 'should go to the News page when the footer news link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.news.title')).click
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.news.header')}$/
    end            
    it 'should go to the Status page when the footer status link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.status.title')).click
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.status.header')}$/
    end    
    it 'should go to the Help page when the footer help link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.help.title')).click
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.help.header')}$/
    end    

  end

  context ' - Layout (Guest users - not logged in) - ' do
    before(:each) do
      visit home_index_path
    end
    it 'should be on the home index page' do
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.index.header')}$/
      find('div.module_header/a', :text => I18n.translate('users_sessions.signin.action'))
    end
    it 'should not see user links' do
      page.should have_no_selector('ul#header_nav_bar//a', :text => I18n.translate('users.show.title'))
      page.should have_no_selector('ul#header_nav_bar//a', :text => I18n.translate('users.index.title'))
    end
    it 'should not see site map on the page' do
      #save_and_open_page
      page.should have_no_selector('div#footer_nav_bar//a', :text => I18n.translate('home.site_map.title'))
    end    
  end

  context ' - Layout (Logged in Regular User) - ' do
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:reg_user_full_create_attr))
      helper_signin(:reg_user_full_create_attr, @me.full_name)
      visit home_index_path
    end
    it 'should have a user item in the top nav bar' do
      page.should have_selector('ul#header_nav_bar//a', :text => I18n.translate('users.show.title'))
    end
  end

  context ' - Layout (Logged in Admin User) - ' do
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
      helper_signin(:admin_user_full_create_attr, @me.full_name)
      visit home_index_path
    end
    it 'should have a user item in the top nav bar 1st item' do
      page.should have_selector('ul#header_nav_bar//a', :text => I18n.translate('users.title') )
    end
    it 'should have a Users link in the left nav bar' do
      find('div#left_content').find('a', :text => I18n.translate('users.title'))
    end
  end

end

describe 'Users Layouts Links Tests - ' do

  context ' - Layout Links (Guest users - not logged in) - ' do
    before(:each) do
      visit home_index_path
      @me = User.guest
    end
    it 'should only see guest system in the left nav' do
      # save_and_open_page
      APPLICATION_NAV.each do | sys_name, system |
        if @me.can_see_system?(system[:id].to_s)
          page.should have_selector(:xpath, "//li[@id=\"lnav_#{system[:id].to_s}\"]")
        else
          page.should_not have_selector(:xpath, "//li[@id=\"lnav_#{system[:id].to_s}\"]")
        end
      end
    end
    it 'should only see the resources a guest can see and can? see' do
      # save_and_open_page
      APPLICATION_NAV.each do | sys_name, system |
        if @me.can_see_system?(system[:id].to_s)
          # page.should have_selector(:xpath, "//li[@id=\"lnav_#{system[:id].to_s}\"]")
          system[:menu_items].each do | menu_key, menu_val |
            ability = Ability.new(@me)
            Rails.logger.debug("T layout_integration_spec check if guest with roles: #{@me.roles}, can? #{menu_val[:action].to_sym} resource #{menu_val[:class_name].to_s}\"]")
            if ability.can?(menu_val[:action].to_sym, menu_val[:class_name].to_s.constantize)
              Rails.logger.debug("T layout_integration_spec guest should see resource #{I18n.translate("systems.#{system[:id].to_s}.menu_items.#{menu_key.to_s}")}\"]")
              page.should have_selector(:xpath, "//li[@id=\"lnav_#{system[:id].to_s}_#{menu_val[:class_name].to_s}_#{menu_val[:action].to_s}\"]")
            else
              Rails.logger.debug("T layout_integration_spec guest should not see resource #{I18n.translate("systems.#{system[:id].to_s}.menu_items.#{menu_key.to_s}")}\"]")
              page.should_not have_selector(:xpath, "//li[@id=\"lnav_#{system[:id].to_s}_#{menu_val[:class_name].to_s}_#{menu_val[:action].to_s} %>\"]")
            end
          end
        end
      end
    end
  end

  context ' - Layout Links (Logged in Regular User) - ' do    
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:reg_user_full_create_attr))
      helper_signin(:reg_user_full_create_attr, @me.full_name)
      visit home_index_path
    end
    it 'should go to Users index page when user clicks top nav Users link' do
      visit home_index_path
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.index.header')}$/
      find('ul#header_nav_bar//a', :text => I18n.translate('users.show.title')).click
      find('#header_tagline_page_header').text.should_not =~ /^#{I18n.translate('users.index.header')}$/
    end
    it 'should go to the Site map page when the footer site map link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.site_map.title')).click
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.site_map.header')}$/
    end            
    it 'should list all authorized systems in the left nav' do
      # save_and_open_page
      APPLICATION_NAV.each do | sys_name, system |
        if @me.can_see_system?(system[:id].to_s)
          page.should have_selector(:xpath, "//li[@id=\"lnav_#{system[:id].to_s}\"]")
        else
          page.should_not have_selector(:xpath, "//li[@id=\"lnav_#{system[:id].to_s}\"]")
        end
      end
    end
    it 'should list all of the resources per system that the item can see and can? see' do
      # save_and_open_page
      APPLICATION_NAV.each do | sys_name, system |
        if @me.can_see_system?(system[:id].to_s)
          # page.should have_selector(:xpath, "//li[@id=\"lnav_#{system[:id].to_s}\"]")
          system[:menu_items].each do | menu_key, menu_val |
            ability = Ability.new(@me)
            Rails.logger.debug("T layout_integration_spec check if guest with roles: #{@me.roles}, can? #{menu_val[:action].to_sym} resource #{menu_val[:class_name].to_s}\"]")
            if ability.can?(menu_val[:action].to_sym, menu_val[:class_name].to_s.constantize)
              Rails.logger.debug("T layout_integration_spec guest should see resource #{I18n.translate("systems.#{system[:id].to_s}.menu_items.#{menu_key.to_s}")}\"]")
              page.should have_selector(:xpath, "//li[@id=\"lnav_#{system[:id].to_s}_#{menu_val[:class_name].to_s}_#{menu_val[:action].to_s}\"]")
            else
              Rails.logger.debug("T layout_integration_spec guest should not see resource #{I18n.translate("systems.#{system[:id].to_s}.menu_items.#{menu_key.to_s}")}\"]")
              page.should_not have_selector(:xpath, "//li[@id=\"lnav_#{system[:id].to_s}_#{menu_val[:class_name].to_s}_#{menu_val[:action].to_s} %>\"]")
            end
          end
        end
      end
    end
  end

  context ' - Layout Links (Logged in Admin User) - ' do
    before(:each) do
      @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
      helper_signin(:admin_user_full_create_attr, @me.full_name)
      visit home_index_path
    end
    it 'should go to Users index page when user clicks top nav Users link' do
      visit home_index_path
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.index.header')}$/
      find('ul#header_nav_bar').find('a', :text => I18n.translate('users.title')).click
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('users.index.header')}$/
    end
    it 'should go to the Site map page when the footer site map link is clicked' do
      find('div#footer_nav_bar').find('a', :text => I18n.translate('home.site_map.title')).click
      find('#header_tagline_page_header').text.should =~ /^#{I18n.translate('home.site_map.header')}$/
    end            
    it 'should list all the systems the item can see in the left nav' do
      # save_and_open_page
      APPLICATION_NAV.each do | sys_name, system |
        if @me.can_see_system?(system[:id].to_s)
          page.should have_selector(:xpath, "//li[@id=\"lnav_#{system[:id].to_s}\"]")
        else
          page.should_not have_selector(:xpath, "//li[@id=\"lnav_#{system[:id].to_s}\"]")
        end
      end
    end
    it 'should list all of the resources per system that the item can see and can? :read' do
      # save_and_open_page
      APPLICATION_NAV.each do | sys_name, system |
        if @me.can_see_system?(system[:id].to_s)
          # page.should have_selector(:xpath, "//li[@id=\"lnav_#{system[:id].to_s}\"]")
          system[:menu_items].each do | menu_key, menu_val |
            ability = Ability.new(@me)
            Rails.logger.debug("T layout_integration_spec check if guest with roles: #{@me.roles}, can? #{menu_val[:action].to_sym} resource #{menu_val[:class_name].to_s}\"]")
            if ability.can?(menu_val[:action].to_sym, menu_val[:class_name].to_s.constantize)
              Rails.logger.debug("T layout_integration_spec guest should see resource #{I18n.translate("systems.#{system[:id].to_s}.menu_items.#{menu_key.to_s}")}\"]")
              page.should have_selector(:xpath, "//li[@id=\"lnav_#{system[:id].to_s}_#{menu_val[:class_name].to_s}_#{menu_val[:action].to_s}\"]")
            else
              Rails.logger.debug("T layout_integration_spec guest should not see resource #{I18n.translate("systems.#{system[:id].to_s}.menu_items.#{menu_key.to_s}")}\"]")
              page.should_not have_selector(:xpath, "//li[@id=\"lnav_#{system[:id].to_s}_#{menu_val[:class_name].to_s}_#{menu_val[:action].to_s} %>\"]")
            end
          end
        end
      end
    end
  end

end

