# spec/integration/states_integration_spec.rb

require 'spec_helper'
include UserIntegrationHelper
include ApplicationHelper

describe 'States Integration Tests' do

  before(:each) do
    @user1 = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
    @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
    helper_signin(:admin_user_full_create_attr, @me.full_name)
    visit home_index_path
    Rails.logger.debug("T states_integration_spec Admin item logged in before - done")
  end
  context 'it should have crud actions available and working' do
    it "should create a new item" do
      num_items = State.count
      visit new_state_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page      
      within(".new_state") do
        page.fill_in 'state_code', :with => 'My Code'
        page.fill_in 'state_name', :with => 'My Name'
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.show.header')}$/
      page.should_not have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\z/  # be whitespace
      find(:xpath, '//*[@id="state_code"]').text.should =~ /\AMy Code\z/  # be new value
      find(:xpath, '//*[@id="state_name"]').text.should =~ /\AMy Name\z/  # be new value
      num_items.should == State.count - 1
    end
    it 'should notify user when trying to create a user missing required fields' do
      item1 = State.create!(FactoryGirl.attributes_for(:state))
      # dont do this if min size == 0
      Rails.logger.debug("T states_integration_spec #{FactoryGirl.attributes_for(:state_min).size}")
      if FactoryGirl.attributes_for(:state_min).size > 0
        num_items = State.count
        visit new_state_path()
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.new.header')}$/
        # save_and_open_page      
        within(".new_state") do
          find(:xpath, '//input[@type="submit"]').click
        end
        # save_and_open_page
        page.driver.status_code.should be 200
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.new.header')}$/
        page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
        find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\z/  # be whitespace
        page.should have_selector(:xpath, '//span[@class="field_with_errors"]')
        num_items.should == State.count
      end
    end
    it 'should be able to edit and update all of an items accessible fields' do
      all_attribs = FactoryGirl.attributes_for(:state_accessible)
      item1 = State.create!(FactoryGirl.attributes_for(:state))
      # item1.deactivated?.should be_false
      visit edit_state_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.edit.header')}$/
      within(".edit_state") do
        all_attribs.each do | at_key, at_val |
          Rails.logger.debug("T states_integration_spec edit update - key-val:#{at_key.to_s}-#{at_val.to_s}")
          if at_val.is_a?(TrueClass)
            Rails.logger.debug("T states_integration_spec edit update - TrueClass")
            page.choose("state_#{at_key.to_s}_true")
            page.should have_selector(:xpath, "//*[@id=\"state_#{at_key.to_s}_true\" and @checked]")
          elsif at_val.is_a?(FalseClass)
            Rails.logger.debug("T states_integration_spec edit update - FalseClass")
            page.choose("state_#{at_key.to_s}_false")
            page.should have_selector(:xpath, "//*[@id=\"state_#{at_key.to_s}_false\" and @checked]")
          else
            # simply fill in the field
            Rails.logger.debug("T states_integration_spec edit update - other class")
            page.fill_in "state_#{at_key.to_s}", :with => at_val
          end
        end
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.show.header')}$/
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ 
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => item1.class.name, :id => item1.id )}$/
      all_attribs.each do | at_key, at_val |
        if at_key.to_s == 'deactivated'
          Rails.logger.debug("T states_integration_spec edit updated show - deactivated")
          find(:xpath, "//*[@id=\"state_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/ 
        elsif at_val.is_a?(TrueClass)
          Rails.logger.debug("T states_integration_spec edit updated show #{at_key.to_s} - TrueClass")
          find(:xpath, "//*[@id=\"state_#{at_key.to_s}\"]").text.should =~ /^true$/
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T states_integration_spec edit updated show #{at_key.to_s} - FalseClass")
          find(:xpath, "//*[@id=\"state_#{at_key.to_s}\"]").text.should =~ /^false$/
        else
          find(:xpath, "//*[@id=\"state_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s}\z/ 
        end
      end
      updated_item = State.find(item1.id)
      all_attribs.each do | at_key, at_val |
        updated_item.send(at_key.to_s).should == at_val
      end
    end
    it 'should be able to show all accessible fields of an item' do
      all_attribs = FactoryGirl.attributes_for(:state_accessible)
      item1 = State.create!(all_attribs)
      # item1.deactivated?.should == all_attribs[:deactivated]
      # visit (state_path, item1, :show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      visit "/states/#{item1.id}?show_deactivated=true" # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.show.header')}$/
      all_attribs.each do | at_key, at_val |
        if at_key.to_s == 'deactivated'
          Rails.logger.debug("T states_integration_spec edit updated show - deactivated")
          find(:xpath, "//*[@id=\"state_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/ 
        elsif at_val.is_a?(TrueClass)
          Rails.logger.debug("T states_integration_spec edit updated show #{at_key.to_s} - TrueClass")
          find(:xpath, "//*[@id=\"state_#{at_key.to_s}\"]").text.should =~ /^true$/
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T states_integration_spec edit updated show #{at_key.to_s} - FalseClass")
          find(:xpath, "//*[@id=\"state_#{at_key.to_s}\"]").text.should =~ /^false$/
        else
          find(:xpath, "//*[@id=\"state_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s}\z/ 
        end
      end
    end
  end
  # context 'it should have deactivated actions available and working' do
  #   it 'should be able to list all items when show_deactivated is set' do
  #     item1 = State.create!(FactoryGirl.attributes_for(:state))
  #     item_deact = State.create!(FactoryGirl.attributes_for(:state).merge({:deactivated => DB_TRUE.to_s}))
  #     visit states_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
  #     # save_and_open_page
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.index.header')}$/
  #     find(:xpath, "//tr[@id=\"state_#{item1.id}\"]/td[@id=\"state_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
  #     # find(:xpath, "(//tr[@id=\"state_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
  #     find(:xpath, "//tr[@id=\"state_#{item1.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
  #     find(:xpath, "//tr[@id=\"state_#{item_deact.id}\"]/td[@id=\"state_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
  #     # find(:xpath, "(//tr[@id=\"state_#{item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
  #     find(:xpath, "//tr[@id=\"state_#{item_deact.id}\"]").should have_selector(:xpath, "td/a", :text => "#{I18n.translate('view_action.reactivate')}")
  #     find(:xpath, "//tr[@id=\"state_#{item_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
  #   end
  #   it 'should be able to list only active items when show_deactivated is off' do
  #     item1 = State.create!(FactoryGirl.attributes_for(:state))
  #     item1.deactivated?.should be_false
  #     item_deact = State.create!(FactoryGirl.attributes_for(:state).merge({:deactivated => DB_TRUE.to_s}))
  #     visit states_path(:show_deactivated => DB_FALSE.to_s) # dont show deactivated records for this test
  #     # save_and_open_page
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.index.header')}$/
  #     page.should have_selector(:xpath, "//tr[@id=\"state_#{item1.id}\"]")
  #     page.should_not have_selector(:xpath, "//tr[@id=\"state_#{item_deact.id}\"]")
  #   end
  #   it 'should not see deactivate option on a deactivated item' do
  #     item_deact = State.create!(FactoryGirl.attributes_for(:state).merge({:deactivated => DB_TRUE.to_s}))
  #     visit states_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
  #     # save_and_open_page
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.index.header')}$/
  #     find(:xpath, "//tr[@id=\"state_#{item_deact.id}\"]/td[@id=\"state_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
  #     find(:xpath, "//tr[@id=\"state_#{item_deact.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.reactivate')}\"]")
  #     find(:xpath, "//tr[@id=\"state_#{item_deact.id}\"]").should_not have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
  #   end
  #   it 'should not see reactivate option on an active item' do
  #     item_active = State.create!(FactoryGirl.attributes_for(:state))
  #     visit states_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
  #     # save_and_open_page
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.index.header')}$/
  #     find(:xpath, "//tr[@id=\"state_#{item_active.id}\"]/td[@id=\"state_#{item_active.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
  #     find(:xpath, "//tr[@id=\"state_#{item_active.id}\"]").should_not have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.reactivate')}\"]")
  #     find(:xpath, "//tr[@id=\"state_#{item_active.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
  #   end
  #   it 'should not see delete on an active item' do
  #     item_active = State.create!(FactoryGirl.attributes_for(:state))
  #     visit states_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
  #     # save_and_open_page
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.index.header')}$/
  #     find(:xpath, "//tr[@id=\"state_#{item_active.id}\"]/td[@id=\"state_#{item_active.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
  #     find(:xpath, "//tr[@id=\"state_#{item_active.id}\"]").should_not have_selector(:xpath, "td/a[@data-method=\"delete\"]")
  #   end
  #   it 'should see delete on a deactivated item' do
  #     item_deact = State.create!(FactoryGirl.attributes_for(:state).merge({:deactivated => DB_TRUE.to_s}))
  #     visit states_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
  #     # save_and_open_page
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.index.header')}$/
  #     find(:xpath, "//tr[@id=\"state_#{item_deact.id}\"]/td[@id=\"state_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
  #     find(:xpath, "//tr[@id=\"state_#{item_deact.id}\"]").should have_selector(:xpath, "td/a[@data-method=\"delete\"]")
  #   end
  #   it 'should GET show the active item as not deactivated' do
  #     item1 = State.create!(FactoryGirl.attributes_for(:state))
  #     item1.deactivated?.should be_false
  #     visit state_path (item1.id)
  #     # save_and_open_page
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.show.header')}$/
  #     find(:xpath, '//*[@id="state_deactivated"]').text.should_not =~ /\A\s*\z/
  #     find(:xpath, '//*[@id="state_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
  #   end
  #   it 'should see the deactivated field in edit' do
  #     item1 = State.create!(FactoryGirl.attributes_for(:state))
  #     item1.deactivated?.should be_false
  #     visit edit_state_path (item1.id)
  #     # save_and_open_page
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.edit.header')}$/
  #     page.should_not have_selector(:xpath, "//*[@id=\"state_deactivated_true\" and @checked]")
  #     page.should have_selector(:xpath, "//*[@id=\"state_deactivated_false\" and @checked]")
  #   end
  #   it 'controller should list items with deactivate/reactivate action/link/button depending upon status' do
  #     item1 = State.create!(FactoryGirl.attributes_for(:state))
  #     item1.deactivated?.should be_false
  #     @item_deact = State.create!(FactoryGirl.attributes_for(:state).merge({:deactivated => DB_TRUE.to_s}))
  #     State.count.should > 1
  #     visit states_path(:show_deactivated => DB_TRUE.to_s) # need to show deactivated records for this test
  #     # save_and_open_page
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.index.header')}$/
  #     find(:xpath, "//tr[@id=\"state_#{item1.id}\"]/td[@id=\"state_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
  #     find(:xpath, "(//tr[@id=\"state_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
  #     find(:xpath, "//tr[@id=\"state_#{@item_deact.id}\"]/td[@id=\"state_#{@item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
  #     find(:xpath, "(//tr[@id=\"state_#{@item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
  #     find(:xpath, "//tr[@id=\"state_#{@item_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
  #   end
  #   it 'Update action should allow a change from deactivated to active' do
  #     item1 = State.create!(FactoryGirl.attributes_for(:state))
  #     item1.deactivated?.should be_false
  #     item1.deactivate
  #     @updated_item = State.find(item1.id)
  #     @updated_item.deactivated?.should be_true
  #     @num_items = State.count
  #     visit ("/states/#{item1.id}/edit?show_deactivated=true")
  #     # save_and_open_page
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.edit.header')}$/
  #     page.should have_selector(:xpath, "//*[@id=\"state_deactivated_true\" and @checked]")
  #     page.should_not have_selector(:xpath, "//*[@id=\"state_deactivated_false\" and @checked]")
  #     within(".edit_state") do
  #       page.choose("state_deactivated_false")
  #       find(:xpath, '//input[@type="submit"]').click
  #     end
  #     # save_and_open_page
  #     page.driver.status_code.should be 200
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('states.edit.header')}$/
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.show.header')}$/
  #     find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~
  #       /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => item1.class.name, :id => @updated_item.id )}/
  #     State.count.should == (@num_items)
  #     find(:xpath, "//*[@id=\"state_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
  #     @updated_item = State.find(item1.id)
  #     @updated_item.deactivated?.should be_false
  #   end
  #   it 'Update action should allow a change from active to deactivated' do
  #     item1 = State.create!(FactoryGirl.attributes_for(:state))
  #     item1.deactivated?.should be_false
  #     @num_items = State.count
  #     visit edit_state_path (item1.id)
  #     # save_and_open_page
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.edit.header')}$/
  #     page.should_not have_selector(:xpath, "//*[@id=\"state_deactivated_true\" and @checked]")
  #     page.should have_selector(:xpath, "//*[@id=\"state_deactivated_false\" and @checked]")
  #     within(".edit_state") do
  #       page.choose("state_deactivated_true")
  #       # select I18n.translate('view_field_value.deactivated'), :from => 'state_deactivated'
  #       find(:xpath, '//input[@type="submit"]').click
  #     end
  #     # save_and_open_page
  #     page.driver.status_code.should be 200
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.show.header')}$/
  #     find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~
  #       /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => item1.class.name, :id => item1.id )}$/
  #     State.count.should == (@num_items)
  #     find(:xpath, "//*[@id=\"state_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
  #     @updated_item = State.find(item1.id)
  #     @updated_item.deactivated?.should be_true
  #   end
  #   it 'should allow a item to be deactivated from the index page' do
  #     item1 = State.create!(FactoryGirl.attributes_for(:state))
  #     item1.deactivated?.should be_false
  #     @item_deact = State.create!(FactoryGirl.attributes_for(:state).merge({:deactivated => DB_TRUE}))
  #     @num_items = State.count
  #     @num_items.should > 1
  #     visit states_path(:show_deactivated => DB_TRUE.to_s)
  #     # save_and_open_page
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.index.header')}$/
  #     find(:xpath, "//tr[@id=\"state_#{item1.id}\"]/td[@id=\"state_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
  #     find(:xpath, "(//tr[@id=\"state_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
  #     find(:xpath, "//tr[@id=\"state_#{item1.id}\"]//a", :text => I18n.translate('view_action.deactivate') ).click
  #     # save_and_open_page
  #     page.driver.status_code.should be 200
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.show.header')}$/
  #     find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~
  #       /^#{I18n.translate('errors.success_method_obj_id', :method => 'deactivate', :obj => item1.class.name, :id => item1.id )}$/
  #     State.count.should == (@num_items)
  #     @updated_item = State.find(item1.id)
  #     @updated_item.deactivated?.should be_true
  #   end
  #   it 'should allow a item to be reactivated from the index page' do
  #     item1 = State.create!(FactoryGirl.attributes_for(:state))
  #     item1.deactivated?.should be_false
  #     @item_deact = State.create!(FactoryGirl.attributes_for(:state).merge({:deactivated => DB_TRUE}))
  #     @num_items = State.count
  #     @num_items.should > 1
  #     visit states_path(:show_deactivated => DB_TRUE.to_s)
  #     # save_and_open_page
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.index.header')}$/
  #     find(:xpath, "//tr[@id=\"state_#{@item_deact.id}\"]/td[@id=\"state_#{@item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.translate('view_field_value.deactivated')}\z/
  #     find(:xpath, "(//tr[@id=\"state_#{@item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
  #     # click on reactivate button of deactivated item
  #     find(:xpath, "//tr[@id=\"state_#{@item_deact.id}\"]//a", :text => I18n.translate('view_action.reactivate') ).click
  #     # save_and_open_page
  #     page.driver.status_code.should be 200
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.show.header')}$/
  #     find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~
  #       /^#{I18n.translate('errors.success_method_obj_id', :method => 'reactivate', :obj => item1.class.name, :id => @item_deact.id )}$/
  #     State.count.should == (@num_items)
  #     find(:xpath, "//*[@id=\"state_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
  #     @updated_item = State.find(item1.id)
  #     @updated_item.deactivated?.should be_false
  #   end    
  #   it 'should not list deactivated items by state' do
  #     item1 = State.create!(FactoryGirl.attributes_for(:state))
  #     item1.deactivated?.should be_false
  #     @item_deact = State.create!(FactoryGirl.attributes_for(:state).merge({:deactivated => DB_TRUE}))
  #     State.count.should > 1
  #     # get states_path
  #     # response.status.should be(200)
  #     visit states_path()
  #     page.driver.status_code.should be 200
  #     # save_and_open_page
  #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('states.index.header')}$/
  #     # find(:xpath, "//tr[@id=\"state_#{item1.id}\"]/td[@class=\"state_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
  #     find(:xpath, "(//tr[@id=\"state_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
  #     page.should_not have_selector(:xpath, "//tr[@id=\"state_#{@item_deact.id}\"]/td[@class=\"state_deactivated\"]", :text => I18n.is_deactivated_or_not(true) )
  #   end   
  # end
end
