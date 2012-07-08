# defaults_integration_spec.rb

# spec/integration/defaults_integration_spec.rb

require 'spec_helper'
include UserIntegrationHelper
include ApplicationHelper

describe 'Defaults Integration Tests' do

  before(:each) do
    @user1 = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
    @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
    helper_signin(:admin_user_full_create_attr, @me.full_name)
    visit home_index_path
    Rails.logger.debug("T defaults_integration_spec Admin item logged in before - done")
  end
  context 'it should have crud actions available and working' do
    it "should create a new item" do
      num_items = Default.count
      visit new_default_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page      
      within(".new_default") do
        page.fill_in 'default_store', :with => 'test store'
        page.fill_in 'default_name', :with => 'my value is'
        page.fill_in 'default_value', :with => 123.45
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.show.header')}$/
      page.should_not have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\z/  # be whitespace
      find(:xpath, '//*[@id="default_store"]').text.should =~ /\Atest store\z/  # be new value
      find(:xpath, '//*[@id="default_name"]').text.should =~ /\Amy value is\z/  # be new value
      find(:xpath, '//*[@id="default_value"]').text.should =~ /\A123.45\z/  # be new value
      num_items.should == Default.count - 1
    end
    it 'should notify user when trying to create a user missing required fields' do
      item1 = Default.create!(FactoryGirl.attributes_for(:default_min))
      # dont do this if min size == 0
      Rails.logger.debug("T defaults_integration_spec #{FactoryGirl.attributes_for(:default_min).size}")
      if FactoryGirl.attributes_for(:default_min).size > 0
        num_items = Default.count
        visit new_default_path()
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.new.header')}$/
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
        # save_and_open_page      
        within(".new_default") do
          find(:xpath, '//input[@type="submit"]').click
        end
        # save_and_open_page
        page.driver.status_code.should be 200
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.new.header')}$/
        page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
        find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\z/  # be whitespace
        page.should have_selector(:xpath, '//span[@class="field_with_errors"]')
        num_items.should == Default.count
      end
    end
    it 'should be able to edit and update an item' do
      all_attribs = FactoryGirl.attributes_for(:default_accessible)
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item1.deactivated?.should be_false
      # visit edit_default_path (item1.id)
      visit ("/defaults/#{item1.id}/edit?show_deactivated=true")
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.edit.header')}$/
      within(".edit_default") do
        # page.fill_in 'default_value', :with => '9876.5432'
        all_attribs.each do | at_key, at_val |
          Rails.logger.debug("T defaults_integration_spec edit update - key-val:#{at_key.to_s}-#{at_val.to_s}")
          if at_val.is_a?(TrueClass)
            Rails.logger.debug("T defaults_integration_spec edit update - TrueClass")
            page.choose("default_#{at_key.to_s}_true")
            page.should have_selector(:xpath, "//*[@id=\"default_#{at_key.to_s}_true\" and @checked]")
          elsif at_val.is_a?(FalseClass)
            Rails.logger.debug("T defaults_integration_spec edit update - FalseClass")
            page.choose("default_#{at_key.to_s}_false")
            page.should have_selector(:xpath, "//*[@id=\"default_#{at_key.to_s}_false\" and @checked]")
          else
            # simply fill in the field
            Rails.logger.debug("T defaults_integration_spec edit update - other class")
            page.fill_in "default_#{at_key.to_s}", :with => at_val
          end
        end
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.show.header')}$/
      # page.should_not have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      # page.should_not have_selector(:xpath, '//span[@class="field_with_errors"]/input[@value="valid.email@example.com"]')
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ 
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => item1.class.name, :id => item1.id )}$/
      all_attribs.each do | at_key, at_val |
        Rails.logger.debug("T defaults_integration_spec edit updated show - value class.name:#{at_val.class.name}")
        if at_key.to_s == 'deactivated'
          Rails.logger.debug("T defaults_integration_spec edit updated show - deactivated")
          find(:xpath, "//*[@id=\"default_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/ 
        elsif at_val.is_a?(TrueClass)
          Rails.logger.debug("T defaults_integration_spec edit updated show #{at_key.to_s} - TrueClass")
          find(:xpath, "//*[@id=\"default_#{at_key.to_s}\"]").text.should =~ /^true$/
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T defaults_integration_spec edit updated show #{at_key.to_s} - FalseClass")
          find(:xpath, "//*[@id=\"default_#{at_key.to_s}\"]").text.should =~ /^false$/
        else
          find(:xpath, "//*[@id=\"default_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s}\z/
        end
      end
      updated_item = Default.find(item1.id)
      all_attribs.each do | at_key, at_val |
        updated_item.send(at_key.to_s).should == at_val
      end
    end
    it 'should be able to show an item' do
      all_attribs = FactoryGirl.attributes_for(:default_accessible)
      item1 = Default.create!(all_attribs)
      item1.deactivated?.should be_true
      # visit default_path (item1.id)
      visit "/defaults/#{item1.id}?show_deactivated=true" # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.show.header')}$/
      # find(:xpath, '//*[@id="default_store"]').text.should =~ /#{attribs[:store]}/
      # find(:xpath, '//*[@id="default_name"]').text.should =~ /#{attribs[:name]}/
      # find(:xpath, '//*[@id="default_value"]').text.should =~ /#{attribs[:value]}/
      all_attribs.each do | at_key, at_val |
        if at_key.to_s == 'deactivated'
          Rails.logger.debug("T defaults_integration_spec edit updated show - deactivated")
          find(:xpath, "//*[@id=\"default_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/ 
        elsif at_val.is_a?(TrueClass)
          Rails.logger.debug("T defaults_integration_spec edit updated show #{at_key.to_s} - TrueClass")
          find(:xpath, "//*[@id=\"default_#{at_key.to_s}\"]").text.should =~ /^true$/
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T defaults_integration_spec edit updated show #{at_key.to_s} - FalseClass")
          find(:xpath, "//*[@id=\"default_#{at_key.to_s}\"]").text.should =~ /^false$/
        else
          find(:xpath, "//*[@id=\"default_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s}\z/ 
        end
      end
    end
  end
  context 'it should have deactivated actions available and working' do
    it 'should be able to list all items when show_deactivated is set' do
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item_deact = Default.create!(FactoryGirl.attributes_for(:default).merge({:deactivated => DB_TRUE.to_s}))
      visit defaults_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.index.header')}$/
      find(:xpath, "//tr[@id=\"default_#{item1.id}\"]/td[@id=\"default_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      # find(:xpath, "(//tr[@id=\"default_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"default_#{item1.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
      find(:xpath, "//tr[@id=\"default_#{item_deact.id}\"]/td[@id=\"default_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      # find(:xpath, "(//tr[@id=\"default_#{item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      find(:xpath, "//tr[@id=\"default_#{item_deact.id}\"]").should have_selector(:xpath, "td/a", :text => "#{I18n.translate('view_action.reactivate')}")
      find(:xpath, "//tr[@id=\"default_#{item_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
    end
    it 'should be able to list only active items when show_deactivated is off' do
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item1.deactivated?.should be_false
      item_deact = Default.create!(FactoryGirl.attributes_for(:default).merge({:deactivated => DB_TRUE.to_s}))
      visit defaults_path(:show_deactivated => DB_FALSE.to_s) # dont show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.index.header')}$/
      page.should have_selector(:xpath, "//tr[@id=\"default_#{item1.id}\"]")
      page.should_not have_selector(:xpath, "//tr[@id=\"default_#{item_deact.id}\"]")
    end
    it 'should not see deactivate option on a deactivated item' do
      item_deact = Default.create!(FactoryGirl.attributes_for(:default).merge({:deactivated => DB_TRUE.to_s}))
      visit defaults_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.index.header')}$/
      find(:xpath, "//tr[@id=\"default_#{item_deact.id}\"]/td[@id=\"default_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "//tr[@id=\"default_#{item_deact.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.reactivate')}\"]")
      find(:xpath, "//tr[@id=\"default_#{item_deact.id}\"]").should_not have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
    end
    it 'should not see reactivate option on an active item' do
      item_active = Default.create!(FactoryGirl.attributes_for(:default))
      visit defaults_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.index.header')}$/
      find(:xpath, "//tr[@id=\"default_#{item_active.id}\"]/td[@id=\"default_#{item_active.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "//tr[@id=\"default_#{item_active.id}\"]").should_not have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.reactivate')}\"]")
      find(:xpath, "//tr[@id=\"default_#{item_active.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
    end
    it 'should not see delete on an active item' do
      item_active = Default.create!(FactoryGirl.attributes_for(:default))
      visit defaults_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.index.header')}$/
      find(:xpath, "//tr[@id=\"default_#{item_active.id}\"]/td[@id=\"default_#{item_active.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "//tr[@id=\"default_#{item_active.id}\"]").should_not have_selector(:xpath, "td/a[@data-method=\"delete\"]")
    end
    it 'should see delete on a deactivated item' do
      item_deact = Default.create!(FactoryGirl.attributes_for(:default).merge({:deactivated => DB_TRUE.to_s}))
      visit defaults_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.index.header')}$/
      find(:xpath, "//tr[@id=\"default_#{item_deact.id}\"]/td[@id=\"default_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "//tr[@id=\"default_#{item_deact.id}\"]").should have_selector(:xpath, "td/a[@data-method=\"delete\"]")
    end
    it 'should GET show the active item as not deactivated' do
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item1.deactivated?.should be_false
      visit default_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.show.header')}$/
      find(:xpath, '//*[@id="default_deactivated"]').text.should_not =~ /\A\s*\z/
      find(:xpath, '//*[@id="default_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    end
    it 'should see the deactivated field in edit' do
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item1.deactivated?.should be_false
      visit edit_default_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.edit.header')}$/
      page.should_not have_selector(:xpath, "//*[@id=\"default_deactivated_true\" and @checked]")
      page.should have_selector(:xpath, "//*[@id=\"default_deactivated_false\" and @checked]")
    end
    it 'controller should list items with deactivate/reactivate action/link/button depending upon status' do
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item1.deactivated?.should be_false
      @item_deact = Default.create!(FactoryGirl.attributes_for(:default).merge({:deactivated => DB_TRUE.to_s}))
      Default.count.should > 1
      visit defaults_path(:show_deactivated => DB_TRUE.to_s) # need to show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.index.header')}$/
      find(:xpath, "//tr[@id=\"default_#{item1.id}\"]/td[@id=\"default_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"default_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"default_#{@item_deact.id}\"]/td[@id=\"default_#{@item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "(//tr[@id=\"default_#{@item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      find(:xpath, "//tr[@id=\"default_#{@item_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
    end
    it 'Update action should allow a change from deactivated to active' do
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item1.deactivated?.should be_false
      item1.deactivate
      @updated_item = Default.find(item1.id)
      @updated_item.deactivated?.should be_true
      @num_items = Default.count
      visit ("/defaults/#{item1.id}/edit?show_deactivated=true")
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.edit.header')}$/
      page.should have_selector(:xpath, "//*[@id=\"default_deactivated_true\" and @checked]")
      page.should_not have_selector(:xpath, "//*[@id=\"default_deactivated_false\" and @checked]")
      within(".edit_default") do
        page.choose("default_deactivated_false")
        # select I18n.translate('view_field_value.active'), :from => 'default_deactivated'
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('defaults.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => @updated_item.class.name, :id => @updated_item.id )}/
      Default.count.should == (@num_items)
      find(:xpath, '//*[@id="default_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      @updated_item = Default.find(item1.id)
      @updated_item.deactivated?.should be_false
    end
    it 'Update action should allow a change from active to deactivated' do
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item1.deactivated?.should be_false
      @num_items = Default.count
      # visit edit_default_path (item1.id)
      visit ("/defaults/#{item1.id}/edit?show_deactivated=true")
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.edit.header')}$/
      page.should_not have_selector(:xpath, "//*[@id=\"default_deactivated_true\" and @checked]")
      page.should have_selector(:xpath, "//*[@id=\"default_deactivated_false\" and @checked]")
      within(".edit_default") do
        page.choose("default_deactivated_true")
        # select I18n.translate('view_field_value.deactivated'), :from => 'default_deactivated'
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => item1.class.name, :id => item1.id )}$/
      Default.count.should == (@num_items)
      find(:xpath, '//*[@id="default_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      @updated_item = Default.find(item1.id)
      @updated_item.deactivated?.should be_true
    end
    it 'should allow a item to be deactivated from the index page' do
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item1.deactivated?.should be_false
      @item_deact = Default.create!(FactoryGirl.attributes_for(:default).merge({:deactivated => DB_TRUE}))
      @num_items = Default.count
      @num_items.should > 1
      visit defaults_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.index.header')}$/
      find(:xpath, "//tr[@id=\"default_#{item1.id}\"]/td[@id=\"default_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"default_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"default_#{item1.id}\"]//a", :text => I18n.translate('view_action.deactivate') ).click
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'deactivate', :obj => item1.class.name, :id => item1.id )}$/
      Default.count.should == (@num_items)
      @updated_item = Default.find(item1.id)
      @updated_item.deactivated?.should be_true
    end
    it 'should allow a item to be reactivated from the index page' do
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item1.deactivated?.should be_false
      @item_deact = Default.create!(FactoryGirl.attributes_for(:default).merge({:deactivated => DB_TRUE}))
      @num_items = Default.count
      @num_items.should > 1
      visit defaults_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.index.header')}$/
      find(:xpath, "//tr[@id=\"default_#{@item_deact.id}\"]/td[@id=\"default_#{@item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.translate('view_field_value.deactivated')}\z/
      find(:xpath, "(//tr[@id=\"default_#{@item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      # click on reactivate button of deactivated item
      find(:xpath, "//tr[@id=\"default_#{@item_deact.id}\"]//a", :text => I18n.translate('view_action.reactivate') ).click
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'reactivate', :obj => @item_deact.class.name, :id => @item_deact.id )}$/
      Default.count.should == (@num_items)
      find(:xpath, '//*[@id="default_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      @updated_item = Default.find(item1.id)
      @updated_item.deactivated?.should be_false
    end    
    it 'should not list deactivated items by default' do
      item1 = Default.create!(FactoryGirl.attributes_for(:default))
      item1.deactivated?.should be_false
      @item_deact = Default.create!(FactoryGirl.attributes_for(:default).merge({:deactivated => DB_TRUE}))
      Default.count.should > 1
      # get defaults_path
      # response.status.should be(200)
      visit defaults_path()
      page.driver.status_code.should be 200
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('defaults.index.header')}$/
      # find(:xpath, "//tr[@id=\"default_#{item1.id}\"]/td[@class=\"default_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"default_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      page.should_not have_selector(:xpath, "//tr[@id=\"default_#{@item_deact.id}\"]/td[@class=\"default_deactivated\"]", :text => I18n.is_deactivated_or_not(true) )
    end   
  end
end
