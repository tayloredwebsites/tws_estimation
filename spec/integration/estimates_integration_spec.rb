# spec/integration/estimates_integration_spec.rb

require 'spec_helper'
include UserIntegrationHelper
include ApplicationHelper

describe 'Estimates Integration Tests' do

  before(:each) do
    @user1 = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
    @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
    helper_signin(:admin_user_full_create_attr, @me.full_name)
    visit home_index_path
    Rails.logger.debug("T estimates_integration_spec Admin item logged in before - done")
    @sales_rep = SalesRep.create!(generate_sales_rep_accessible_attributes(user_id = @user1.id))
    @job_type = FactoryGirl.create(:job_type)
    @state = FactoryGirl.create(:state)
    @estimate_attributes = generate_estimate_accessible_attributes(:sales_rep_id => @sales_rep.id, :job_type_id => @job_type.id, :state_id => @state.id )
  end
  context 'it should have crud actions available and working' do
    it "should create a new item" do
      num_items = Estimate.count
      visit new_estimate_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page      
      Rails.logger.debug("T estimates_integration_spec - @estimate_attributes = #{@estimate_attributes.inspect.to_s}")
      within(".new_estimate") do
        @estimate_attributes.each do |at_key, at_value|
          if at_value.is_a?(TrueClass)
            page.choose("estimate_#{at_key.to_s}_true")
          elsif at_value.is_a?(FalseClass)
            page.choose("estimate_#{at_key.to_s}_false")
          elsif at_key =~ /_id$/
            # do association selects manually (capybara select method only selects by value, not ID)
          else
            page.fill_in "estimate_#{at_key.to_s}", :with => at_value
          end
        end
        page.select @sales_rep.username.to_s, :from => 'estimate_sales_rep_id'
        page.select @job_type.name.to_s, :from => 'estimate_job_type_id'
        page.select @state.name.to_s, :from => 'estimate_state_id'
        # page.should have('Testing for Estimate Assemblies here')
        # page.fill_in 'estimate_description', :with => attribs[:description]
        # save_and_open_page      
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      page.should_not have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      page.should_not have_selector(:xpath, '//*', :text => 'translation missing:')
      @estimate_attributes.each do | at_key, at_val |
        if at_key.to_s == 'deactivated'
          Rails.logger.debug("T estimates_integration_spec updated attribs - deactivated")
          find(:xpath, "//*[@id=\"estimate_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/ 
        elsif at_val.is_a?(TrueClass)
          Rails.logger.debug("T estimates_integration_spec updated attribs - #{at_key.to_s} - TrueClass")
          find(:xpath, "//*[@id=\"estimate_#{at_key.to_s}\"]").text.should =~ /^true$/
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T estimates_integration_spec updated attribs - #{at_key.to_s} - FalseClass")
          find(:xpath, "//*[@id=\"estimate_#{at_key.to_s}\"]").text.should =~ /^false$/
        elsif at_key =~ /_id$/
          # do association selects manually (capybara select method only selects by value, not ID)
        else
          Rails.logger.debug("T estimates_integration_spec updated attribs - #{at_key.to_s}")
          find(:xpath, "//*[@id=\"estimate_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s}\z/ 
        end
      end
      find(:xpath, '//*[@id="estimate_sales_rep"]').text.should =~ /\A#{@sales_rep.nil_to_s}\z/
      find(:xpath, '//*[@id="estimate_job_type"]').text.should =~ /\A#{@job_type.nil_to_s}\z/
      find(:xpath, '//*[@id="estimate_state"]').text.should =~ /\A#{@state.nil_to_s}\z/
      # page.should have('Testing for Estimate Assemblies here')
      # find(:xpath, '//*[@id="estimate_description"]').text.should =~ /\AMy Description\z/  # be new value
      num_items.should == Estimate.count - 1
    end
    it 'should notify user when trying to create a user missing required fields' do
      # dont do this if min size == 0
      Rails.logger.debug("T estimates_integration_spec #{FactoryGirl.attributes_for(:estimate_min).size}")
      if FactoryGirl.attributes_for(:estimate_min).size > 0
        num_items = Estimate.count
        visit new_estimate_path()
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.new.header')}$/
        # save_and_open_page      
        within(".new_estimate") do
          find(:xpath, '//input[@type="submit"]').click
        end
        # save_and_open_page
        page.driver.status_code.should be 200
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.new.header')}$/
        page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
        find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\z/  # be whitespace
        page.should have_selector(:xpath, '//span[@class="field_with_errors"]')
        num_items.should == Estimate.count
      end
    end
    it 'should be able to edit and update all of an items accessible fields' do
      all_attribs = @estimate_attributes
      item1 = Estimate.create!(@estimate_attributes)
      item1.deactivated?.should be_false
      visit edit_estimate_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      within(".edit_estimate") do
        all_attribs.each do | at_key, at_val |
          Rails.logger.debug("T estimates_integration_spec edit update - key-val:#{at_key.to_s}-#{at_val.to_s}")
          if at_val.is_a?(TrueClass)
            Rails.logger.debug("T estimates_integration_spec edit update - TrueClass")
            page.choose("estimate_#{at_key.to_s}_true")
            page.should have_selector(:xpath, "//*[@id=\"estimate_#{at_key.to_s}_true\" and @checked]")
          elsif at_val.is_a?(FalseClass)
            Rails.logger.debug("T estimates_integration_spec edit update - FalseClass")
            page.choose("estimate_#{at_key.to_s}_false")
            page.should have_selector(:xpath, "//*[@id=\"estimate_#{at_key.to_s}_false\" and @checked]")
          elsif at_key =~ /_id$/
            # do association selects manually (capybara select method only selects by value, not ID)
          else
            # simply fill in the field
            Rails.logger.debug("T estimates_integration_spec edit update - other class")
            page.fill_in "estimate_#{at_key.to_s}", :with => at_val
          end
        end
        page.select @sales_rep.username.to_s, :from => 'estimate_sales_rep_id'
        page.select @job_type.name.to_s, :from => 'estimate_job_type_id'
        page.select @state.name.to_s, :from => 'estimate_state_id'
        # page.should have('Testing for Estimate Assemblies here')
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      page.should_not have_selector(:xpath, '//*', :text => 'translation missing:')
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ 
        /^#{I18n.translate('errors.success_method_obj_name', :method => 'update', :obj => 'Estimate', :name => item1.desc )}$/
      all_attribs.each do | at_key, at_val |
        if at_key.to_s == 'deactivated'
          Rails.logger.debug("T estimates_integration_spec edit updated show - deactivated")
          find(:xpath, "//*[@id=\"estimate_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/ 
        elsif at_val.is_a?(TrueClass)
          Rails.logger.debug("T estimates_integration_spec edit updated show #{at_key.to_s} - TrueClass")
          find(:xpath, "//*[@id=\"estimate_#{at_key.to_s}\"]").text.should =~ /^true$/
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T estimates_integration_spec edit updated show #{at_key.to_s} - FalseClass")
          find(:xpath, "//*[@id=\"estimate_#{at_key.to_s}\"]").text.should =~ /^false$/
        elsif at_key =~ /_id$/
          # do association selects manually (capybara select method only selects by value, not ID)
        else
          find(:xpath, "//*[@id=\"estimate_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s}\z/ 
        end
      end
      find(:xpath, '//*[@id="estimate_sales_rep"]').text.should =~ /\A#{@sales_rep.nil_to_s}\z/
      find(:xpath, '//*[@id="estimate_job_type"]').text.should =~ /\A#{@job_type.nil_to_s}\z/
      find(:xpath, '//*[@id="estimate_state"]').text.should =~ /\A#{@state.nil_to_s}\z/
      # page.should have('Testing for Estimate Assemblies here')
      updated_item = Estimate.find(item1.id)
      all_attribs.each do | at_key, at_val |
        updated_item.send(at_key.to_s).should == at_val
      end
    end
    it 'should be able to show all accessible fields of an item' do
      all_attribs = @estimate_attributes
      item1 = Estimate.create!(@estimate_attributes)
      item1.deactivated?.should == all_attribs[:deactivated]
      # visit (estimate_path, item1, :show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      visit "/estimates/#{item1.id}?show_deactivated=true" # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      all_attribs.each do | at_key, at_val |
        if at_key.to_s == 'deactivated'
          Rails.logger.debug("T estimates_integration_spec edit updated show - deactivated")
          find(:xpath, "//*[@id=\"estimate_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/ 
        elsif at_val.is_a?(TrueClass)
          Rails.logger.debug("T estimates_integration_spec edit updated show #{at_key.to_s} - TrueClass")
          find(:xpath, "//*[@id=\"estimate_#{at_key.to_s}\"]").text.should =~ /^true$/
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T estimates_integration_spec edit updated show #{at_key.to_s} - FalseClass")
          find(:xpath, "//*[@id=\"estimate_#{at_key.to_s}\"]").text.should =~ /^false$/
        elsif at_key =~ /_id$/
          # do association selects manually (capybara select method only selects by value, not ID)
        else
          find(:xpath, "//*[@id=\"estimate_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s}\z/ 
        end
      end
      find(:xpath, '//*[@id="estimate_sales_rep"]').text.should =~ /\A#{@sales_rep.nil_to_s}\z/
      find(:xpath, '//*[@id="estimate_job_type"]').text.should =~ /\A#{@job_type.nil_to_s}\z/
      find(:xpath, '//*[@id="estimate_state"]').text.should =~ /\A#{@state.nil_to_s}\z/
      # page.should have('Testing for Estimate Assemblies here')
    end
  end
  context 'component layouts - ' do
    before(:each) do
      @item1 = Estimate.create!(@estimate_attributes)
    end
    context 'should have index/list row links working' do
      before(:each) do
        visit estimates_path()
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
        page.should have_selector(:xpath, "//tr[@id=\"estimate_#{@item1.id}\"]/td/a", :text =>  I18n.translate('view_action.view') )
        page.should have_selector(:xpath, "//tr[@id=\"estimate_#{@item1.id}\"]/td/a", :text =>  I18n.translate('view_action.edit') )
      end
      it 'has clickable show button' do
        find(:xpath, "//tr[@id=\"estimate_#{@item1.id}\"]/td/a", :text =>  I18n.translate('view_action.view') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      end
      it 'has clickable edit button' do
        find(:xpath, "//tr[@id=\"estimate_#{@item1.id}\"]/td/a", :text =>  I18n.translate('view_action.edit') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      end
    end
    context 'should have index links working' do
      before(:each) do
        visit estimates_path()
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('estimates.new.action') )
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('estimates.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.new.header')}$/
      end
    end
    context 'should have list links working' do
      before(:each) do
        visit list_estimates_path()
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.list.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('estimates.new.action') )
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('estimates.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.new.header')}$/
      end
    end
    # context 'should have menu links working' do
    #   before(:each) do
    #     visit estimates_menu_path()
    #     # save_and_open_page
    #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.menu.header')}$/
    #     page.should have_selector(:xpath, "//span[@id='index_action']/a", :text => I18n.translate('estimates.index.action') )
    #     page.should have_selector(:xpath, "//span[@id='list_action']/a", :text => I18n.translate('estimates.list.action') )
    #     page.should have_selector(:xpath, "//span[@id='new_action']/a", :text => I18n.translate('estimates.new.action') )
    #   end
    #   it 'has clickable index link' do
    #     find(:xpath, "//span[@id='index_action']/a", :text => I18n.translate('estimates.index.action') ).click
    #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
    #   end
    #   it 'has clickable list link' do
    #     find(:xpath, "//span[@id='list_action']/a", :text => I18n.translate('estimates.list.action') ).click
    #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.list.header')}$/
    #   end
    #   it 'has clickable create new link' do
    #     find(:xpath, "//span[@id='new_action']/a", :text => I18n.translate('estimates.new.action') ).click
    #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.new.header')}$/
    #   end
    # end
    context 'should have new/create links working' do
      before(:each) do
        visit new_estimate_path()
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.new.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('estimates.index.action') )
      end
      it 'has clickable index link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('estimates.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
      end
    end
    context 'should have edit/update links working' do
      before(:each) do
        visit edit_estimate_path(@item1.id)
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('estimates.show.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('estimates.index.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('estimates.list.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('estimates.new.action') )
      end
      it 'has clickable show button' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('estimates.show.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      end
      it 'has clickable index link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('estimates.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
      end
      it 'has clickable list link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('estimates.list.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.list.header')}$/
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('estimates.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.new.header')}$/
      end
    end
    context 'should have show links working' do
      before(:each) do
        visit estimate_path(@item1.id)
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('estimates.edit.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('estimates.index.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('estimates.list.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('estimates.new.action') )
      end
      it 'has clickable edit button' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('estimates.edit.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      end
      it 'has clickable index link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('estimates.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
      end
      it 'has clickable list link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('estimates.list.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.list.header')}$/
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('estimates.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.new.header')}$/
      end
    end
  end
  context 'it should have deactivated actions available and working' do
    before(:each) do
      # # have existing instance variables already available for testing: @sales_rep, @job_type, @state, @estimate_attributes
      # all_attribs = @estimate_attributes
      # item1 = Estimate.create!(@estimate_attributes)
      # item1.deactivated?.should be_false
      @user2 = User.create!(FactoryGirl.attributes_for(:user_create))
      @sales_rep2 = SalesRep.create!(generate_sales_rep_accessible_attributes(user_id = @user2.id))
      @estimate_deact_attributes = generate_estimate_accessible_attributes(:sales_rep_id => @sales_rep2.id, :job_type_id => @job_type.id, :state_id => @state.id, :deactivated => true )
    end
    it 'should be able to list all items when show_deactivated is set' do
      item1 = Estimate.create!(@estimate_attributes)
      item_deact = Estimate.create!(@estimate_deact_attributes)
      visit estimates_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
      find(:xpath, "//tr[@id=\"estimate_#{item1.id}\"]/td[@id=\"estimate_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "//tr[@id=\"estimate_#{item1.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
      find(:xpath, "//tr[@id=\"estimate_#{item_deact.id}\"]/td/a[@data-method=\"put\"]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      find(:xpath, "//tr[@id=\"estimate_#{item_deact.id}\"]/td[@id=\"estimate_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "//tr[@id=\"estimate_#{item_deact.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.reactivate')}\"]")
      find(:xpath, "//tr[@id=\"estimate_#{item_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
    end
    it 'should be able to list only active items when show_deactivated is off' do
      item1 = Estimate.create!(@estimate_attributes)
      item1.deactivated?.should be_false
      item_deact = Estimate.create!(@estimate_deact_attributes)
      # item_deact = Estimate.create!(FactoryGirl.attributes_for(:estimate).merge({:deactivated => DB_TRUE.to_s}))
      visit estimates_path(:show_deactivated => DB_FALSE.to_s) # dont show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
      page.should have_selector(:xpath, "//tr[@id=\"estimate_#{item1.id}\"]")
      page.should_not have_selector(:xpath, "//tr[@id=\"estimate_#{item_deact.id}\"]")
    end
    it 'should not see deactivate option on a deactivated item' do
      item_deact = Estimate.create!(@estimate_deact_attributes)
      # item_deact = Estimate.create!(FactoryGirl.attributes_for(:estimate).merge({:deactivated => DB_TRUE.to_s}))
      visit estimates_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
      find(:xpath, "//tr[@id=\"estimate_#{item_deact.id}\"]/td[@id=\"estimate_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "//tr[@id=\"estimate_#{item_deact.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.reactivate')}\"]")
      find(:xpath, "//tr[@id=\"estimate_#{item_deact.id}\"]").should_not have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
    end
    it 'should not see reactivate option on an active item' do
      item_active = Estimate.create!(@estimate_attributes)
      visit estimates_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
      find(:xpath, "//tr[@id=\"estimate_#{item_active.id}\"]/td[@id=\"estimate_#{item_active.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "//tr[@id=\"estimate_#{item_active.id}\"]").should_not have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.reactivate')}\"]")
      find(:xpath, "//tr[@id=\"estimate_#{item_active.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
    end
    it 'should not see delete on an active item' do
      item_active = Estimate.create!(@estimate_attributes)
      visit estimates_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
      find(:xpath, "//tr[@id=\"estimate_#{item_active.id}\"]/td[@id=\"estimate_#{item_active.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "//tr[@id=\"estimate_#{item_active.id}\"]").should_not have_selector(:xpath, "td/a[@data-method=\"delete\"]")
    end
    it 'should see delete on a deactivated item' do
      item_deact = Estimate.create!(@estimate_deact_attributes)
      # item_deact = Estimate.create!(FactoryGirl.attributes_for(:estimate).merge({:deactivated => DB_TRUE.to_s}))
      visit estimates_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
      find(:xpath, "//tr[@id=\"estimate_#{item_deact.id}\"]/td[@id=\"estimate_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "//tr[@id=\"estimate_#{item_deact.id}\"]").should have_selector(:xpath, "td/a[@data-method=\"delete\"]")
    end
    it 'should GET show the active item as not deactivated' do
      item1 = Estimate.create!(@estimate_attributes)
      item1.deactivated?.should be_false
      visit estimate_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      find(:xpath, '//*[@id="estimate_deactivated"]').text.should_not =~ /\A\s*\z/
      find(:xpath, '//*[@id="estimate_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    end
    it 'should see the deactivated field in edit' do
      item1 = Estimate.create!(@estimate_attributes)
      item1.deactivated?.should be_false
      visit edit_estimate_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      page.should_not have_selector(:xpath, "//*[@id=\"estimate_deactivated_true\" and @checked]")
      page.should have_selector(:xpath, "//*[@id=\"estimate_deactivated_false\" and @checked]")
    end
    it 'controller should list items with deactivate/reactivate action/link/button depending upon status' do
      item1 = Estimate.create!(@estimate_attributes)
      item1.deactivated?.should be_false
      item_deact = Estimate.create!(@estimate_deact_attributes)
      # @item_deact = Estimate.create!(FactoryGirl.attributes_for(:estimate).merge({:deactivated => DB_TRUE.to_s}))
      Estimate.count.should > 1
      visit estimates_path(:show_deactivated => DB_TRUE.to_s) # need to show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
      find(:xpath, "//tr[@id=\"estimate_#{item1.id}\"]/td[@id=\"estimate_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"estimate_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"estimate_#{item_deact.id}\"]/td[@id=\"estimate_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "(//tr[@id=\"estimate_#{item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      find(:xpath, "//tr[@id=\"estimate_#{item_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
    end
    it 'Update action should allow a change from deactivated to active' do
      item1 = Estimate.create!(@estimate_attributes)
      item1.deactivated?.should be_false
      item1.deactivate
      @updated_item = Estimate.find(item1.id)
      @updated_item.deactivated?.should be_true
      @num_items = Estimate.count
      visit ("/estimates/#{item1.id}/edit?show_deactivated=true")
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      page.should have_selector(:xpath, "//*[@id=\"estimate_deactivated_true\" and @checked]")
      page.should_not have_selector(:xpath, "//*[@id=\"estimate_deactivated_false\" and @checked]")
      within(".edit_estimate") do
        page.choose("estimate_deactivated_false")
        find(:xpath, '//input[@type="submit"]').click
      end
      @updated_item = Estimate.find(item1.id)
      @updated_item.deactivated?.should be_false
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('estimates.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_name', :method => 'update', :obj => 'Estimate', :name => @updated_item.desc )}/
      Estimate.count.should == (@num_items)
      find(:xpath, "//*[@id=\"estimate_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      @updated_item = Estimate.find(item1.id)
      @updated_item.deactivated?.should be_false
    end
    it 'Update action should allow a change from active to deactivated' do
      item1 = Estimate.create!(@estimate_attributes)
      item1.deactivated?.should be_false
      @num_items = Estimate.count
      # visit edit_estimate_path (item1.id)
      visit ("/estimates/#{item1.id}/edit?show_deactivated=true")
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      page.should_not have_selector(:xpath, "//*[@id=\"estimate_deactivated_true\" and @checked]")
      page.should have_selector(:xpath, "//*[@id=\"estimate_deactivated_false\" and @checked]")
      within(".edit_estimate") do
        page.choose("estimate_deactivated_true")
        # select I18n.translate('view_field_value.deactivated'), :from => 'estimate_deactivated'
        # save_and_open_page
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      @updated_item = Estimate.find(item1.id)
      @updated_item.deactivated?.should be_true
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_name', :method => 'update', :obj => 'Estimate', :name => @updated_item.desc )}$/
      Estimate.count.should == (@num_items)
      find(:xpath, "//*[@id=\"estimate_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
    end
    it 'should allow a item to be deactivated from the index page' do
      num_items = Estimate.count
      item1 = Estimate.create!(@estimate_attributes)
      item1.deactivated?.should be_false
      Estimate.count.should == num_items + 1
      visit estimates_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
      find(:xpath, "//tr[@id=\"estimate_#{item1.id}\"]/td[@id=\"estimate_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"estimate_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"estimate_#{item1.id}\"]//a", :text => I18n.translate('view_action.deactivate') ).click
      @updated_item = Estimate.find(item1.id)
      @updated_item.deactivated?.should be_true
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'deactivate', :obj => 'Estimate', :id => @updated_item.id )}$/
      Estimate.count.should == (num_items + 1)
    end
    it 'should allow a item to be reactivated from the index page' do
      num_items = Estimate.count
      item1 = Estimate.create!(@estimate_attributes)
      item1.deactivated?.should be_false
      item_deact = Estimate.create!(@estimate_deact_attributes)
      # item_deact = Estimate.create!(FactoryGirl.attributes_for(:estimate).merge({:deactivated => DB_TRUE}))
      Estimate.count.should == num_items + 2
      visit estimates_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
      find(:xpath, "//tr[@id=\"estimate_#{item_deact.id}\"]/td[@id=\"estimate_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.translate('view_field_value.deactivated')}\z/
      find(:xpath, "(//tr[@id=\"estimate_#{item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      # click on reactivate button of deactivated item
      find(:xpath, "//tr[@id=\"estimate_#{item_deact.id}\"]//a", :text => I18n.translate('view_action.reactivate') ).click
      @updated_item = Estimate.find(item_deact.id)
      @updated_item.deactivated?.should be_false
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'reactivate', :obj => 'Estimate', :id => @updated_item.id )}$/
      Estimate.count.should == num_items + 2
      find(:xpath, "//*[@id=\"estimate_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    end    
    it 'should not list deactivated items by estimate' do
      item1 = Estimate.create!(@estimate_attributes)
      item1.deactivated?.should be_false
      item_deact = Estimate.create!(@estimate_deact_attributes)
      # item_deact = Estimate.create!(FactoryGirl.attributes_for(:estimate).merge({:deactivated => DB_TRUE}))
      Estimate.count.should > 1
      # get estimates_path
      # response.status.should be(200)
      visit estimates_path()
      page.driver.status_code.should be 200
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
      # find(:xpath, "//tr[@id=\"estimate_#{item1.id}\"]/td[@class=\"estimate_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"estimate_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      page.should_not have_selector(:xpath, "//tr[@id=\"estimate_#{item_deact.id}\"]/td[@class=\"estimate_deactivated\"]", :text => I18n.is_deactivated_or_not(true) )
    end   
  end
  context 'translations missing - ' do
    before(:each) do
    end
    it 'should not be found on menu page' do
      visit estimates_menu_path()
      # save_and_open_page
      page.should_not have_selector(:xpath, '//*', :text => 'translation missing:')
    end
    it 'should not be found on index page' do
      item1 = Estimate.create!(@estimate_attributes)
      # item2 = Estimate.create!(@estimate_attributes)
      visit estimates_path()
      # save_and_open_page
      page.should_not have_selector(:xpath, '//*', :text => 'translation missing:')
    end
    it 'should not be found on list page' do
      item1 = Estimate.create!(@estimate_attributes)
      # item2 = Estimate.create!(@estimate_attributes)
      visit list_estimates_path
      # save_and_open_page
      page.should_not have_selector(:xpath, '//*', :text => 'translation missing:')
    end
    # it 'should not be found on menu page'
    it 'should not be found on new page' do
      visit new_estimate_path
      # save_and_open_page
      page.should_not have_selector(:xpath, '//*', :text => 'translation missing:')
    end
    it 'should not be found on create page' do
      # this is tested in the 'should create a new item' test
    end
    it 'should not be found on edit page' do
      item1 = Estimate.create!(@estimate_attributes)
      visit edit_estimate_path(item1.id)
      # save_and_open_page
      page.should_not have_selector(:xpath, '//*', :text => 'translation missing:')
    end
    it 'should not be found on update page' do
      # this is tested in the 'should be able to edit and update all of an items accessible fields' test
    end
    it 'should not be found on show page' do
      item1 = Estimate.create!(@estimate_attributes)
      visit estimate_path(item1.id)
      # save_and_open_page
      page.should_not have_selector(:xpath, '//*', :text => 'translation missing:')
    end
  end

  context 'it should list estimate assemblies checkboxes - ' do
    before(:each) do
      FactoryGirl.create(:assembly_create)
      FactoryGirl.create(:assembly_create)
      FactoryGirl.create(:assembly_create, :required => true)
      FactoryGirl.create(:assembly_create)
      FactoryGirl.create(:assembly_create, :deactivated => true)
      FactoryGirl.create(:assembly_create, :deactivated => true, :required => true)
      FactoryGirl.create(:assembly_create)
      FactoryGirl.create(:assembly_create)
      Rails.logger.debug("T estimates_integration_spec 'assemblies created' in before :each - done")
    end
    it 'should have a checkbox for all active assemblies' do
      Assembly.count.should == 8
      item1 = Estimate.create!(@estimate_attributes)
      visit edit_estimate_path(item1.id)
      # save_and_open_page
      Assembly.all.each do |ass|
        # Rails.logger.debug("T estimates_integration_spec assembly: #{ass.inspect.to_s}")
        if !ass.deactivated
          Rails.logger.debug("T estimates_integration_spec assembly is active")
          page.should have_selector(:xpath, "//*[@id=\"estimate_assemblies_#{ass.id}\"]")
        end
      end
      visit estimate_path(item1.id)
      # save_and_open_page
      Assembly.all.each do |ass|
        # Rails.logger.debug("T estimates_integration_spec assembly: #{ass.inspect.to_s}")
        if !ass.deactivated
          Rails.logger.debug("T estimates_integration_spec assembly is active")
          page.should have_selector(:xpath, "//*[@id=\"estimate_assemblies_#{ass.id}\"]")
        end
      end
    end
    it 'should have a checkbox for all required assemblies (not deactivated)' do
      Assembly.count.should == 8
      item1 = Estimate.create!(@estimate_attributes)
      visit edit_estimate_path(item1.id)
      # save_and_open_page
      Assembly.all.each do |ass|
        # Rails.logger.debug("T estimates_integration_spec assembly: #{ass.inspect.to_s}")
        if ass.required && !ass.deactivated
          Rails.logger.debug("T estimates_integration_spec assembly is required")
          page.should have_selector(:xpath, "//*[@id=\"estimate_assemblies_#{ass.id}\"]")
        end
      end
      visit estimate_path(item1.id)
      # save_and_open_page
      Assembly.all.each do |ass|
        # Rails.logger.debug("T estimates_integration_spec assembly: #{ass.inspect.to_s}")
        if ass.required && !ass.deactivated
          Rails.logger.debug("T estimates_integration_spec assembly is required")
          page.should have_selector(:xpath, "//*[@id=\"estimate_assemblies_#{ass.id}\"]")
        end
      end
    end
    it 'should still have previously checked checkbox as checked if assembly is deactivated' do
      Assembly.count.should == 8
      item1 = Estimate.create!(@estimate_attributes)
      visit edit_estimate_path(item1.id)
      # save_and_open_page
      page.check("estimate_assemblies_4")
      # save_and_open_page
      find(:xpath, '//input[@type="submit"]').click
      # save_and_open_page
      visit edit_estimate_path(item1.id)
      # save_and_open_page
      page.should have_selector(:xpath, "//*[@id=\"estimate_assemblies_4\"]")
      page.should have_selector(:xpath, "//*[@id=\"estimate_assemblies_4\" and @checked]")
      ass_4 = Assembly.find(4)
      ass_4.deactivated = true
      ass_4.save!
      visit edit_estimate_path(item1.id)
      # save_and_open_page
      page.should have_selector(:xpath, "//*[@id=\"estimate_assemblies_4\"]")
      page.should have_selector(:xpath, "//*[@id=\"estimate_assemblies_4\" and @checked]")
      visit estimate_path(item1.id)
      # save_and_open_page
      page.should have_selector(:xpath, "//*[@id=\"estimate_assemblies_4\"]")
      page.should have_selector(:xpath, "//*[@id=\"estimate_assemblies_4\" and @checked]")
    end

  end

  context 'it should list estimate components - '
end
