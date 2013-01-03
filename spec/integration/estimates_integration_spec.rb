# spec/integration/estimates_integration_spec.rb

require 'spec_helper'
include UserIntegrationHelper
include ApplicationHelper

describe 'Estimates Integration Tests', :js => false do

  before(:each) do
    @user1 = User.create!(FactoryGirl.attributes_for(:reg_user_full_create_attr))
    @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
    @sales_rep = SalesRep.create!(generate_sales_rep_accessible_attributes(user_id = @user1.id))
    @job_type = FactoryGirl.create(:job_type)
    @state = FactoryGirl.create(:state)
    @estimate_attributes = generate_estimate_accessible_attributes(:sales_rep_id => @sales_rep.id, :job_type_id => @job_type.id, :state_id => @state.id )
  end
  context 'it should have crud actions available and working' do
    before(:each) do
      helper_signin(:admin_user_full_create_attr, @me.full_name)
      visit home_index_path
      Rails.logger.debug("T estimates_integration_spec Admin item logged in")
    end
    it "should create a new item" do
      num_items = Estimate.count
      visit new_estimate_path()
      # save_and_open_page      
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
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
      # it 'should prevent user from losing estimate numbers - create only does estimate, then opens up edit for numbers'
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      page.should_not have_selector(:xpath, '//*', :text => 'translation missing:')
      @estimate_attributes.each do | at_key, at_val |
        # if at_key.to_s == 'deactivated'
        #   Rails.logger.debug("T estimates_integration_spec updated attribs - deactivated")
        #   find(:xpath, "//*[@id=\"estimate_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/
        if at_val.is_a?(TrueClass)
          Rails.logger.debug("T estimates_integration_spec updated attribs - #{at_key.to_s} - TrueClass")
          page.should have_selector(:xpath, "//*[@id=\"estimate_#{at_key.to_s}_true\"]")
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T estimates_integration_spec updated attribs - #{at_key.to_s} - FalseClass")
          page.should have_selector(:xpath, "//*[@id=\"estimate_#{at_key.to_s}_false\"]")
        elsif at_key =~ /_id$/
          # do association selects manually (capybara select method only selects by value, not ID)
        else
          Rails.logger.debug("T estimates_integration_spec updated attribs - #{at_key.to_s}")
          find(:xpath, "//*[@id=\"estimate_#{at_key.to_s}\"]").value.should =~ /\A#{at_val.to_s}\z/
        end
      end
      find(:xpath, '//*[@id="estimate_sales_rep_id"]').text.should =~ /\A#{@sales_rep.username}\z/
      find(:xpath, '//*[@id="estimate_job_type_id"]').value.should =~ /\A#{@job_type.id.to_s}\z/
      find(:xpath, '//*[@id="estimate_state_id"]').value.should =~ /\A#{@state.id.to_s}\z/
      find(:xpath, '//input[@type="submit"]').click
      # save_and_open_page
      page.driver.status_code.should be 200
      page.should_not have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      # it 'should prevent user from losing estimate numbers - create only does estimate, then opens up edit for numbers'
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
        # it 'should prevent user from losing estimate numbers - create only does estimate, then opens up edit for numbers'
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.new.header')}$/
        page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
        # find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\z/  # be whitespace
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
        /^#{I18n.translate('errors.warn_method_obj_name_warn', :method => 'update', :obj => 'Estimate', :name => item1.desc, :warn => I18n.translate('error_messages.missing_required_field') )}$/
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
      helper_signin(:admin_user_full_create_attr, @me.full_name)
      visit home_index_path
      Rails.logger.debug("T estimates_integration_spec Admin item logged in")
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
      helper_signin(:admin_user_full_create_attr, @me.full_name)
      visit home_index_path
      Rails.logger.debug("T estimates_integration_spec Admin item logged in")
      @user2 = User.create!(FactoryGirl.attributes_for(:user_create))
      @sales_rep2 = SalesRep.create!(generate_sales_rep_accessible_attributes(user_id = @user2.id))
      @estimate_deact_attributes = generate_estimate_accessible_attributes(:sales_rep_id => @sales_rep2.id, :job_type_id => @job_type.id, :state_id => @state.id, :deactivated => DB_TRUE )
    end
    it 'should be able to list all items when show_deactivated is set' do
      item1 = Estimate.create!(@estimate_attributes)
      item_deact = Estimate.create!(@estimate_deact_attributes)
      Estimate.count.should == 2
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
    it 'should not be able to select a deactivated sales reps' do
      # Rails.logger.debug("T Create @user_deact")
      @user_deact = FactoryGirl.create(:user_create)
      # Rails.logger.debug("T Create @sales_rep_deact")
      @sales_rep_deact = FactoryGirl.create(:sales_rep_accessible_create, :user => @user_deact)
      # Rails.logger.debug("T @sales_rep_deact = #{@sales_rep_deact.inspect.to_s}")
      # Rails.logger.debug("T @sales_rep_deact.user = #{@sales_rep_deact.user.inspect.to_s}")
      num_items = Estimate.count
      visit new_estimate_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page      
      Rails.logger.debug("T estimates_integration_spec - @estimate_attributes = #{@estimate_attributes.inspect.to_s}")
      page.should have_selector(:xpath, "//select[@id=\"estimate_sales_rep_id\"]/option", :text => @user1.username)
      page.should have_selector(:xpath, "//select[@id=\"estimate_sales_rep_id\"]/option", :text => @user2.username)
      page.should_not have_selector(:xpath, "//select[@id=\"estimate_sales_rep_id\"]/option", :text => @user_deact.username)
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
      find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~
        /^#{I18n.translate('errors.warn_method_obj_name_warn', :method => 'update', :obj => 'Estimate', :name => @updated_item.desc, :warn => I18n.translate('error_messages.missing_required_field') )}$/
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
      find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~
        /^#{I18n.translate('errors.warn_method_obj_name_warn', :method => 'update', :obj => 'Estimate', :name => @updated_item.desc, :warn => I18n.translate('error_messages.missing_required_field') )}$/
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
      find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~
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
      find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~
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
      helper_signin(:admin_user_full_create_attr, @me.full_name)
      visit home_index_path
      Rails.logger.debug("T estimates_integration_spec Admin item logged in")
      FactoryGirl.create(:assembly_create)
      FactoryGirl.create(:assembly_create)
      FactoryGirl.create(:assembly_create, :required => DB_TRUE)
      FactoryGirl.create(:assembly_create)
      FactoryGirl.create(:assembly_create, :deactivated => DB_TRUE)
      FactoryGirl.create(:assembly_create, :deactivated => DB_TRUE, :required => DB_TRUE)
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

  context 'it should list estimate components - ' do
    before(:each) do
      helper_signin(:admin_user_full_create_attr, @me.full_name)
      visit home_index_path
      Rails.logger.debug("T estimates_integration_spec Admin item logged in")
      helper_load_defaults
      helper_load_component_types
      helper_load_components
      helper_load_assemblies
      helper_load_assembly_components
    end
    it 'should list the estimate assemblies in new/create, edit/update and view after' do #, :js => true do # scripting off for testing in spec_helper.rb
      num_items = Estimate.count
      visit new_estimate_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page      
      Rails.logger.debug("T estimates_integration_spec - @estimate_attributes = #{@estimate_attributes.inspect.to_s}")
      # fill in estimate form with estimate attributes for create
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
        # these are not necessary because these assemblies are set at required.
        # page.check("estimate_assemblies_#{@assemblies[2].id.to_s}")
        # page.check("estimate_assemblies_#{@assemblies[3].id.to_s}")
        # save_and_open_page      
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      # page.driver.status_code.should be 200
      # response.status.should be(200)  # status is not available with :js => true (selenium driver)
      page.should_not have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      page.should_not have_selector(:xpath, '//*', :text => 'translation missing:')
      # input form should show all components for all (not deactivated) assemblies
      page.should have_selector(:xpath, "//*[@id=\"assembly_#{@assemblies[0].id.to_s}\"]")
      page.should have_selector(:xpath, "//*[@id=\"assembly_#{@assemblies[1].id.to_s}\"]")
      page.should have_selector(:xpath, "//*[@id=\"assembly_#{@assemblies[2].id.to_s}\"]")
      page.should have_selector(:xpath, "//*[@id=\"assembly_#{@assemblies[3].id.to_s}\"]")
      # it 'should not list deactivated assemblies'
      page.should_not have_selector(:xpath, "//*[@id=\"assembly_#{@assemblies[4].id.to_s}\"]")
      # note @assemblies[2] and @assemblies[3] are checked because they are required
      within(".edit_estimate") do
        # page.fill_in "estimate_components_#{@assemblies[2].id.to_s}_#{@components[3].id.to_s}", :with => '876.12'
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      # page.driver.status_code.should be 200
      # response.status.should be(200)  # status is not available with :js => true (selenium driver)
      page.should_not have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      page.should_not have_selector(:xpath, '//*', :text => 'translation missing:')
      page.should have_selector(:xpath, "//*[@id=\"estimate_assemblies_#{@assemblies[0].id.to_s}\"]")
      page.should_not have_selector(:xpath, "//*[@id=\"estimate_assemblies_#{@assemblies[0].id.to_s}\" and @checked]")
      page.should have_selector(:xpath, "//*[@id=\"estimate_assemblies_#{@assemblies[1].id.to_s}\"]")
      page.should_not have_selector(:xpath, "//*[@id=\"estimate_assemblies_#{@assemblies[1].id.to_s}\" and @checked]")
      page.should have_selector(:xpath, "//*[@id=\"estimate_assemblies_#{@assemblies[2].id.to_s}\"]")
      page.should have_selector(:xpath, "//*[@id=\"estimate_assemblies_#{@assemblies[2].id.to_s}\" and @checked]")
      page.should have_selector(:xpath, "//*[@id=\"estimate_assemblies_#{@assemblies[3].id.to_s}\"]")
      page.should have_selector(:xpath, "//*[@id=\"estimate_assemblies_#{@assemblies[3].id.to_s}\" and @checked]")
      # it 'should not list deactivated assemblies'
      page.should_not have_selector(:xpath, "//*[@id=\"estimate_assemblies_#{@assemblies[4].id.to_s}\"]")
      # show form should show all checked components for all assemblies
      page.should_not have_selector(:xpath, "//*[@id=\"assembly_#{@assemblies[0].id.to_s}\"]")
      page.should_not have_selector(:xpath, "//*[@id=\"assembly_#{@assemblies[1].id.to_s}\"]")
      page.should have_selector(:xpath, "//*[@id=\"assembly_#{@assemblies[2].id.to_s}\"]")
      page.should have_selector(:xpath, "//*[@id=\"assembly_#{@assemblies[3].id.to_s}\"]")
      page.should_not have_selector(:xpath, "//*[@id=\"assembly_#{@assemblies[4].id.to_s}\"]")
      # find(:xpath, "//*[@id=\"estimate_components_#{@assemblies[2].id.to_s}_#{@components[3].id.to_s}\"]").text.should_not =~ /\s*876.12\s*/ 
      # find(:xpath, '//*[@id="estimate_description"]').text.should =~ /\AMy Description\z/  # be new value
      num_items.should == Estimate.count - 1
    end
    it 'should show the Assembly Components section for the required assemblies in edit/update' do #, :js => true do # scripting off for testing in spec_helper.rb
      VIEWS_SCRIPTING = true # spec_helper clears this (turning off javascript dependent code), thus bypass the assembly check box status
      all_attribs = @estimate_attributes
      estimate = Estimate.create!(@estimate_attributes)
      num_items = Estimate.count
      estimate.deactivated?.should be_false
      Rails.logger.debug ("VVVVSCRIPTING VIEWS_SCRIPTING before visit = #{VIEWS_SCRIPTING.inspect.to_s}")
      visit edit_estimate_path (estimate.id)
      Rails.logger.debug ("VVVVSCRIPTING VIEWS_SCRIPTING after visit = #{VIEWS_SCRIPTING.inspect.to_s}")
      # save_and_open_page
      page.should have_selector(:xpath, "//div[@id=\"assembly_#{@assemblies[0].id.to_s}\" and @class=\"assembly show_hide\"]")
      page.should_not have_selector(:xpath, "//div[@id=\"assembly_#{@assemblies[0].id.to_s}\" and @class=\"assembly only_show\"]")
      page.should have_selector(:xpath, "//div[@id=\"assembly_#{@assemblies[1].id.to_s}\" and @class=\"assembly show_hide\"]")
      page.should_not have_selector(:xpath, "//div[@id=\"assembly_#{@assemblies[1].id.to_s}\" and @class=\"assembly only_show\"]")
      page.should have_selector(:xpath, "//div[@id=\"assembly_#{@assembly_all.id.to_s}\" and @class=\"assembly show_hide\"]")
      page.should_not have_selector(:xpath, "//div[@id=\"assembly_#{@assembly_all.id.to_s}\" and @class=\"assembly only_show\"]")
      page.should have_selector(:xpath, "//div[@id=\"assembly_#{@assembly_total.id.to_s}\" and @class=\"assembly show_hide\"]")
      page.should_not have_selector(:xpath, "//div[@id=\"assembly_#{@assembly_total.id.to_s}\" and @class=\"assembly only_show\"]")
      # it 'should not show Assembly Component sections for deactivated assemblies'
      page.should_not have_selector(:xpath, "//div[@id=\"assembly_#{@assembly_deact.id.to_s}\" and @class=\"assembly show_hide\"]")
      page.should_not have_selector(:xpath, "//div[@id=\"assembly_#{@assembly_deact.id.to_s}\" and @class=\"assembly only_show\"]")
      num_items.should == Estimate.count
    end
  end

  
  context 'Regular non-grid Components - ' do
    before(:each) do
      helper_signin(:admin_user_full_create_attr, @me.full_name)
      visit home_index_path
      Rails.logger.debug("T estimates_integration_spec Admin item logged in")
      helper_load_defaults
      helper_load_component_types
      helper_load_components
      helper_load_assemblies
      helper_load_assembly_components
    end
    it 'should list the components for the selected estimate assemblies in new/create view after create' do #, :js => true do # scripting off for testing in spec_helper.rb
      all_attribs = @estimate_attributes
      estimate = Estimate.create!(@estimate_attributes)
      num_items = Estimate.count
      estimate.deactivated?.should be_false
      Rails.logger.debug ("VVVVSCRIPTING VIEWS_SCRIPTING before visit = #{VIEWS_SCRIPTING.inspect.to_s}")
      visit edit_estimate_path (estimate.id)
      Rails.logger.debug ("VVVVSCRIPTING VIEWS_SCRIPTING after visit = #{VIEWS_SCRIPTING.inspect.to_s}")
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      Rails.logger.debug("T estimates_integration_spec - @estimate_attributes = #{@estimate_attributes.inspect.to_s}")
      within(".edit_estimate") do
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
        page.check("estimate_assemblies_#{@assemblies[1].id.to_s}")
        # must specify all of the defaulted values for calculation to be predictable (factory values change with different runs)
        find("#assembly_#{@assemblies[1].id.to_s}/h3").click # note this assembly will not be checked in save_and_open_page due to no javascript testing here
        # changes to an unchecked assembly - should not be updated or accumulated
        page.fill_in "estimate_components_#{@assemblies[0].id.to_s}_#{@components[0].id.to_s}", :with => '2.34' #1_1
        # it 'should not list deactivate components'
        page.should_not have_selector(:xpath, "//input[@id=\"estimate_components_#{@assemblies[1].id.to_s}_#{@components[0].id.to_s}\"]")
        # deactivated component - should not show up
        # page.fill_in "estimate_components_#{@assemblies[1].id.to_s}_#{@components[0].id.to_s}", :with => '3.45' # 2_1
        page.fill_in "estimate_components_#{@assemblies[1].id.to_s}_#{@components[1].id.to_s}", :with => '4.56' # 2_2
        page.fill_in "estimate_components_note_#{@assemblies[1].id.to_s}_#{@components[1].id.to_s}", :with => 'Component 1 Note' # 2_2
        # make sure blank overrides default with 0.00
        page.fill_in "estimate_components_#{@assemblies[1].id.to_s}_#{@components[2].id.to_s}", :with => '' # 2_3
        page.fill_in "estimate_components_#{@assembly_all.id.to_s}_#{@components[3].id.to_s}", :with => '6.78' # 3_4
        page.fill_in "estimate_components_#{@assembly_all.id.to_s}_#{@components[4].id.to_s}", :with => '7.89' # 3_5
        # it 'should not list components with deactivated component types'
        page.should_not have_selector(:xpath, "//input[@id=\"estimate_components_#{@assembly_all.id.to_s}_#{@components[5].id.to_s}\"]") # 3_6
        page.should_not have_selector(:xpath, "//span[@id=\"component_type_#{@assembly_all.id.to_s}_#{@component_types[2].id.to_s}\"]")
        page.fill_in "estimate_components_#{@assembly_all.id.to_s}_#{@components[6].id.to_s}", :with => '9.01' # 3_7
        page.fill_in "estimate_components_#{@assembly_all.id.to_s}_#{@components[7].id.to_s}", :with => '1.34' # 3_8
        page.fill_in "estimate_components_#{@assembly_total.id.to_s}_#{@components[9].id.to_s}", :with => '2.45' # 4_10
        page.fill_in "estimate_components_#{@assembly_total.id.to_s}_#{@assembly_components[10].component_id.to_s}", :with => 2.5 # 4_11
        # save_and_open_page      
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      # page.driver.status_code.should be 200
      # response.status.should be(200)  # status is not available with :js => true (selenium driver)
      page.should_not have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      page.should_not have_selector(:xpath, '//*', :text => 'translation missing:')
      # it 'should not list components with unchecked assemblies'
      page.should_not have_selector(:xpath, "//*[@id=\"assembly_#{@assemblies[0].id.to_s}\"]")
      page.should_not have_selector(:xpath, "//span[@id=\"estimate_components_#{@assemblies[0].id.to_s}_#{@components[0].id.to_s}\"]") # 1_1
      # it 'should not list deactivated components
      page.should_not have_selector(:xpath, "//span[@id=\"estimate_components_#{@assemblies[1].id.to_s}_#{@components[0].id.to_s}\"]") # 2_1
      page.should have_selector(:xpath, "//*[@id=\"assembly_#{@assemblies[1].id.to_s}\"]")
      # it 'should not list deactivated components'
      page.should_not have_selector(:xpath, "//span[@id=\"estimate_components_#{@assemblies[1].id.to_s}_#{@component_deact.id.to_s}\"]")
      find(:xpath, "//span[@id=\"estimate_components_#{@assemblies[1].id.to_s}_#{@components[1].id.to_s}\"]").text.should =~ /4.56/ # 2_2
      find(:xpath, "//span[@id=\"estimate_components_note_#{@assemblies[1].id.to_s}_#{@components[1].id.to_s}\"]").text.should =~ /Component 1 Note/ # 2_2
      find(:xpath, "//span[@id=\"estimate_components_#{@assemblies[1].id.to_s}_#{@components[2].id.to_s}\"]").text.should =~ /0.00/ # 2_3
      find(:xpath, "//span[@id=\"component_type_total_#{@assemblies[1].id.to_s}_#{@component_types[1].id.to_s}\"]").text.should =~ /4.56/
      # it 'should not accumulate hours to totals column'
      find(:xpath, "//td[@id=\"assembly_component_type_totals_#{@assemblies[1].id.to_s}_total\"]").text.should_not =~/^4.56$/
      find(:xpath, "//td[@id=\"assembly_component_type_totals_#{@assemblies[1].id.to_s}_total\"]").text.should =~/^0.00$/
      find(:xpath, "//span[@id=\"estimate_components_#{@assembly_all.id.to_s}_#{@components[3].id.to_s}\"]").text.should =~ /6.78/ # 3_4
      find(:xpath, "//span[@id=\"component_type_total_#{@assembly_all.id.to_s}_#{@component_types[0].id.to_s}\"]").text.should =~ /6.78/
      find(:xpath, "//span[@id=\"estimate_components_#{@assembly_all.id.to_s}_#{@components[4].id.to_s}\"]").text.should =~ /7.89/ # 3_5
      find(:xpath, "//span[@id=\"component_type_total_#{@assembly_all.id.to_s}_#{@component_types[1].id.to_s}\"]").text.should =~ /7.89/
      # it 'should not list components with deactivated component types'
      page.should_not have_selector(:xpath, "//span[@id=\"estimate_components_#{@assembly_all.id.to_s}_#{@components[5].id.to_s}\"]") # 3_6
      page.should_not have_selector(:xpath, "//span[@id=\"component_type_#{@assembly_all.id.to_s}_#{@component_types[2].id.to_s}\"]")        
      find(:xpath, "//span[@id=\"estimate_components_#{@assembly_all.id.to_s}_#{@components[6].id.to_s}\"]").text.should =~ /9.01/ # 3_7
      find(:xpath, "//span[@id=\"estimate_components_#{@assembly_all.id.to_s}_#{@components[7].id.to_s}\"]").text.should =~ /1.34/ # 3_8
      find(:xpath, "//span[@id=\"component_type_total_#{@assembly_all.id.to_s}_#{@component_types[3].id.to_s}\"]").text.should =~ /10.35/
      # it 'should not accumulate hours to totals column'
      # find(:xpath, "//td[@id=\"assembly_component_type_totals_#{@assembly_all.id.to_s}_total\"]").text.should =~/^25.02$/
      find(:xpath, "//td[@id=\"assembly_component_type_totals_#{@assembly_all.id.to_s}_total\"]").text.should =~/^17.13$/
      find(:xpath, "//span[@id=\"estimate_components_#{@assembly_total.id.to_s}_#{@components[9].id.to_s}\"]").text.should =~ /2.45/ # 4_10
      find(:xpath, "//span[@id=\"component_type_total_#{@assembly_total.id.to_s}_#{@component_types[0].id.to_s}\"]").text.should =~ /2.45/
      # find(:xpath, "//span[@id=\"component_type_total_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}\"]").text.should =~ /^42.61$/ # grid total
      # it 'should not accumulate hours to totals column'
      find(:xpath, "//td[@id=\"component_type_total_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_total\"]").text.should =~ /^42.61$/ # grid total
      find(:xpath, "//td[@id=\"assembly_component_type_totals_#{@assembly_total.id.to_s}_total\"]").text.should =~/^45.06$/
      # grand totals
      # it should not show single total lines, except at component type breaks
      # find(:xpath, "//span[@id=\"grand_total\"]").text.should =~ /^62.19$/
      # it should show subtotals and grand totals by component types.
      find(:xpath, "//td[@id=\"grand_totals_type_total\"]").text.should =~ /^62.19$/
      num_items.should == Estimate.count
    end
  end
  
  context 'it should only let non-admin sales rep see, create or modify own estimates' do
    before(:each) do
      helper_signin(:reg_user_full_create_attr, @user1.full_name)
      Rails.logger.debug("T estimates_integration_spec regular user logged in")
      visit home_index_path
      Rails.logger.debug("T estimates_integration_spec User1 logged in")
      @user2 = User.create!(FactoryGirl.attributes_for(:user_create))
      @sales_rep2 = SalesRep.create!(generate_sales_rep_accessible_attributes(user_id = @user2.id))
      @estimate_rep2_attributes = generate_estimate_accessible_attributes(:sales_rep_id => @sales_rep2.id, :job_type_id => @job_type.id, :state_id => @state.id)
    end
    it 'should only index own estimates' do
      estimate_rep1 = Estimate.create!(@estimate_attributes)
      estimate_rep2 = Estimate.create!(@estimate_rep2_attributes)
      Estimate.count.should == 2
      visit estimates_path()
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
      page.should have_selector(:xpath, "//tr[@id=\"estimate_#{estimate_rep1.id.to_s}\"]")
      page.should_not have_selector(:xpath, "//tr[@id=\"estimate_#{estimate_rep2.id.to_s}\"]")
    end
    it 'should only list own estimates' do
      estimate_rep1 = Estimate.create!(@estimate_attributes)
      estimate_rep2 = Estimate.create!(@estimate_rep2_attributes)
      Estimate.count.should == 2
      visit estimates_path()
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.index.header')}$/
      page.should have_selector(:xpath, "//tr[@id=\"estimate_#{estimate_rep1.id.to_s}\"]")
      page.should_not have_selector(:xpath, "//tr[@id=\"estimate_#{estimate_rep2.id.to_s}\"]")
    end
    it 'should not allow sales rep to new/create estimates for other sales reps' do
      num_items = Estimate.count
      visit new_estimate_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page      
      # Rails.logger.debug("T estimates_integration_spec - @estimate_attributes = #{@estimate_attributes.inspect.to_s}")
      page.should have_selector(:xpath, "//select[@id=\"estimate_sales_rep_id\"]/option", :text => @user1.username)
      page.should_not have_selector(:xpath, "//select[@id=\"estimate_sales_rep_id\"]/option", :text => @user2.username)
    end
    it 'should not see estimates by Sales Rep menu item' do
      visit new_estimate_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page      
      # Rails.logger.debug("T estimates_integration_spec - @estimate_attributes = #{@estimate_attributes.inspect.to_s}")
      page.should have_selector(:xpath, "//li[@id=\"lnav_estim_Estimate_list\"]")
      page.should_not have_selector(:xpath, "//li[@id=\"lnav_estim_Estimate_menu_Estimate_index\"]")
      page.should_not have_selector(:xpath, "//li[@id=\"lnav_estim_Estimate_menu_Estimate_list\"]")
    end
    it 'should allow sales rep to view own estimates' do
      estimate_rep1 = Estimate.create!(@estimate_attributes)
      Estimate.count.should == 1
      visit estimate_path(estimate_rep1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
    end
    it 'should not allow sales rep to view estimates for other sales reps' do
      estimate_rep2 = Estimate.create!(@estimate_rep2_attributes)
      Estimate.count.should == 1
      visit estimate_path(estimate_rep2.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('estimates.show.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.errors.header')}$/
    end
    it 'should allow sales rep to edit own estimates' do
      estimate_rep1 = Estimate.create!(@estimate_attributes)
      Estimate.count.should == 1
      visit edit_estimate_path(estimate_rep1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
    end
    it 'should not allow sales rep to edit estimates for other sales reps' do
      estimate_rep2 = Estimate.create!(@estimate_rep2_attributes)
      Estimate.count.should == 1
      visit edit_estimate_path(estimate_rep2.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('estimates.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('home.errors.header')}$/
    end
  end
  
  context 'Totals Grid - ' do
    before(:each) do
      helper_signin(:admin_user_full_create_attr, @me.full_name)
      visit home_index_path
      Rails.logger.debug("T estimates_integration_spec Admin item logged in")
      helper_load_defaults
      helper_load_component_types
      helper_load_components
      helper_load_assemblies
      helper_load_assembly_components
    end
    it 'should list a column for each component type only if component_type is active (and not in estimate) and in_totals_grid is true' do #, :js => true do # see VIEWS_SCRIPTING = false in spec_helper.rb
      all_attribs = @estimate_attributes
      estimate = Estimate.create!(@estimate_attributes)
      Estimate.count.should == 1
      estimate.deactivated?.should be_false
      visit edit_estimate_path (estimate.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      Rails.logger.debug("T estimates_integration_spec - @estimate_attributes = #{@estimate_attributes.inspect.to_s}")
      # following tests dependent upon helper_load_assemblies, spec_helper.rb helper_load_component_types and helper_load_components
      page.should have_selector(:xpath, "//table[@id=\"totals_grid_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}\"]")
      page.should have_selector(:xpath, "//table[@id=\"totals_grid_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}\"]//th[@class=\"grid_row_head\"]", :text => @component_types[0].description)  # not in totals grid
      page.should have_selector(:xpath, "//table[@id=\"totals_grid_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}\"]//th[@class=\"grid_row_head\"]", :text => @component_types[1].description)  # not in totals grid
      page.should_not have_selector(:xpath, "//table[@id=\"totals_grid_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}\"]//th[@class=\"grid_row_head\"]", :text => @component_types[2].description)  # deactivated
      page.should_not have_selector(:xpath, "//table[@id=\"totals_grid_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}\"]//th[@class=\"grid_row_head\"]", :text => @component_types[3].description)  # regular
      page.should have_selector(:xpath, "//table[@id=\"totals_grid_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}\"]//th[@class=\"grid_row_head\"]", :text => @component_types[4].description)  # regular
      page.should_not have_selector(:xpath, "//table[@id=\"totals_grid_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}\"]//th[@class=\"grid_row_head\"]", :text => @component_types[5].description)  # regular
      page.should_not have_selector(:xpath, "//table[@id=\"totals_grid_#{@assembly_total.id.to_s}\"]//th[@class=\"grid_row_head\"]", :text => @component_types[4].description)  # totals component type
      # within(".edit_estimate") do
      #   # save_and_open_page
      #   # check assemblies so they are seen in show after update
      #   page.check("estimate_assemblies_#{@assemblies[0].id.to_s}")
      #   page.check("estimate_assemblies_#{@assemblies[1].id.to_s}")
      #   page.check("estimate_assemblies_#{@assemblies[2].id.to_s}")
      #   save_and_open_page
      #   find(:xpath, '//input[@type="submit"]').click
      # end
      # save_and_open_page
    end
    it 'should have required class on required components, and not_required class on others' do
      all_attribs = @estimate_attributes
      estimate = Estimate.create!(@estimate_attributes)
      Estimate.count.should == 1
      estimate.deactivated?.should be_false
      visit edit_estimate_path (estimate.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      Rails.logger.debug("T estimates_integration_spec - @estimate_attributes = #{@estimate_attributes.inspect.to_s}")
      # following tests dependent upon helper_load_assemblies, spec_helper.rb helper_load_component_types and helper_load_components
      # 9th component type is not 'has_totals', so it is a regular component with a default value (note the not editable flag is ignored here)
      page.should have_selector(:xpath, "//span[@class='component_value not_required']/input[@id=\"estimate_components_#{@assembly_components[0].assembly.id.to_s}_#{@assembly_components[0].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[@class='component_value not_required']/input[@id=\"estimate_components_#{@assembly_components[2].assembly.id.to_s}_#{@assembly_components[2].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[@class='component_value required']/input[@id=\"estimate_components_#{@assembly_components[3].assembly.id.to_s}_#{@assembly_components[3].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[@class='component_value not_required']/input[@id=\"estimate_components_#{@assembly_components[4].assembly.id.to_s}_#{@assembly_components[4].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[@class='component_value not_required']/input[@id=\"estimate_components_#{@assembly_components[5].assembly.id.to_s}_#{@assembly_components[5].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[@class='component_value required']/input[@id=\"estimate_components_#{@assembly_components[7].assembly.id.to_s}_#{@assembly_components[7].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[@class='component_value not_required']/input[@id=\"estimate_components_#{@assembly_components[8].assembly.id.to_s}_#{@assembly_components[8].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[@class='component_value not_required']/input[@id=\"estimate_components_#{@assembly_components[9].assembly.id.to_s}_#{@assembly_components[9].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[@class='component_value not_required']/input[@id=\"estimate_components_#{@assembly_components[10].assembly.id.to_s}_#{@assembly_components[10].component.id.to_s}\"]")
      # should not have required flag, because it is not an input field
      # page.should have_selector(:xpath, "//span[@class='component_value not_required']/input[@id=\"estimate_components_#{@assembly_components[11].assembly.id.to_s}_#{@assembly_components[11].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[@class='component_value not_required']/input[@id=\"estimate_components_#{@assembly_components[12].assembly.id.to_s}_#{@assembly_components[12].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[@class='component_value not_required']/input[@id=\"estimate_components_#{@assembly_components[13].assembly.id.to_s}_#{@assembly_components[13].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[@class='component_value not_required']/input[@id=\"estimate_components_#{@assembly_components[14].assembly.id.to_s}_#{@assembly_components[14].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[@class='component_value required']/input[@id=\"estimate_components_#{@assembly_components[15].assembly.id.to_s}_#{@assembly_components[15].component.id.to_s}\"]")
    end
    it 'should give an warning on empty required fields' do
      all_attribs = @estimate_attributes
      estimate = Estimate.create!(@estimate_attributes)
      Estimate.count.should == 1
      estimate.deactivated?.should be_false
      visit edit_estimate_path (estimate.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      Rails.logger.debug("T estimates_integration_spec - @estimate_attributes = #{@estimate_attributes.inspect.to_s}")
      # following tests dependent upon helper_load_assemblies, spec_helper.rb helper_load_component_types and helper_load_components
      # 9th component type is not 'has_totals', so it is a regular component with a default value (note the not editable flag is ignored here)
      page.should have_selector(:xpath, "//span[@class='component_value required']/input[@id=\"estimate_components_#{@assembly_components[3].assembly.id.to_s}_#{@assembly_components[3].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[@class='component_value required']/input[@id=\"estimate_components_#{@assembly_components[7].assembly.id.to_s}_#{@assembly_components[7].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[@class='component_value required']/input[@id=\"estimate_components_#{@assembly_components[15].assembly.id.to_s}_#{@assembly_components[15].component.id.to_s}\"]")
      within(".edit_estimate") do
        # save_and_open_page
        # check assemblies so they are seen in show after update
        page.check("estimate_assemblies_#{@assemblies[0].id.to_s}")
        page.check("estimate_assemblies_#{@assemblies[1].id.to_s}")
        page.check("estimate_assemblies_#{@assemblies[2].id.to_s}")
        page.fill_in "estimate_components_#{@assembly_components[3].assembly.id.to_s}_#{@assembly_components[3].component.id.to_s}", :with => ''
        page.fill_in "estimate_components_#{@assembly_components[7].assembly.id.to_s}_#{@assembly_components[7].component.id.to_s}", :with => ''
        page.fill_in "estimate_components_#{@assembly_components[15].assembly.id.to_s}_#{@assembly_components[15].component.id.to_s}", :with => ''
        # save_and_open_page
        Rails.logger.debug("TESTING estimates_integration_spec Start of Update!")
        find(:xpath, '//input[@type="submit"]').click
      end
      Rails.logger.debug("TESTING estimates_integration_spec Update completed!")
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~ /#{I18n.translate('errors.warn_method_obj_name_warn', :method => 'update', :obj => 'Estimate', :name => estimate.desc, :warn => I18n.translate('error_messages.missing_required_field') )}/
      page.should have_selector(:xpath, "//span[contains(@class, 'field_with_errors')]/label[@for=\"estimate_components_#{@assembly_components[3].assembly.id.to_s}_#{@assembly_components[3].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[contains(@class, 'field_with_errors')]/span[@id=\"estimate_components_#{@assembly_components[3].assembly.id.to_s}_#{@assembly_components[3].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[contains(@class, 'field_with_errors')]/label[@for=\"estimate_components_#{@assembly_components[7].assembly.id.to_s}_#{@assembly_components[7].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[contains(@class, 'field_with_errors')]/span[@id=\"estimate_components_#{@assembly_components[7].assembly.id.to_s}_#{@assembly_components[7].component.id.to_s}\"]")
      # grid has label field in first td (column) of tr (row)
      page.should have_selector(:xpath, "//tr[contains(@class, 'field_with_errors')]/td[@id=\"grid_label_#{@assembly_components[15].assembly.id.to_s}_#{@assembly_components[15].component.component_type.id.to_s}_#{@assembly_components[15].component.id.to_s}\"]/span[@class=\"field_error\"]")
      # edit it again, so estimate component records exists, to show error message
      visit edit_estimate_path (estimate.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      Rails.logger.debug("T estimates_integration_spec - @estimate_attributes = #{@estimate_attributes.inspect.to_s}")
      # following tests dependent upon helper_load_assemblies, spec_helper.rb helper_load_component_types and helper_load_components
      # 9th component type is not 'has_totals', so it is a regular component with a default value (note the not editable flag is ignored here)
      page.should have_selector(:xpath, "//span[contains(@class, 'field_with_errors')]/label[@for=\"estimate_components_#{@assembly_components[3].assembly.id.to_s}_#{@assembly_components[3].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[contains(@class, 'field_with_errors')]/span/input[@id=\"estimate_components_#{@assembly_components[3].assembly.id.to_s}_#{@assembly_components[3].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[contains(@class, 'field_with_errors')]/label[@for=\"estimate_components_#{@assembly_components[7].assembly.id.to_s}_#{@assembly_components[7].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//span[contains(@class, 'field_with_errors')]/span/input[@id=\"estimate_components_#{@assembly_components[7].assembly.id.to_s}_#{@assembly_components[7].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//tr[contains(@class, 'field_with_errors')]/td[@id=\"grid_label_#{@assembly_components[15].assembly.id.to_s}_#{@assembly_components[15].component.component_type.id.to_s}_#{@assembly_components[15].component.id.to_s}\"]/label")
      page.should have_selector(:xpath, "//tr[contains(@class, 'field_with_errors')]/td[@id=\"grid_label_#{@assembly_components[15].assembly.id.to_s}_#{@assembly_components[15].component.component_type.id.to_s}_#{@assembly_components[15].component.id.to_s}\"]/span/input")
      # grid has label field in first td (column) of tr (row)
      page.should have_selector(:xpath, "//tr[contains(@class, 'field_with_errors')]/td[@id=\"grid_label_#{@assembly_components[15].assembly.id.to_s}_#{@assembly_components[15].component.component_type.id.to_s}_#{@assembly_components[15].component.id.to_s}\"]/span[@class=\"field_error\"]")
    end
    it 'should give an warning on unconverted hours' do
      all_attribs = @estimate_attributes
      estimate = Estimate.create!(@estimate_attributes)
      Estimate.count.should == 1
      estimate.deactivated?.should be_false
      visit edit_estimate_path (estimate.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      page.should have_selector(:xpath, "//input[@id=\"estimate_components_#{@assembly_components[12].assembly.id.to_s}_#{@assembly_components[12].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//td[contains(@class, 'warning') and @id='grand_totals_type_2']")
      within(".edit_estimate") do
        # save_and_open_page
        # check assemblies so they are seen in show after update
        page.check("estimate_assemblies_#{@assemblies[0].id.to_s}")
        page.check("estimate_assemblies_#{@assemblies[1].id.to_s}")
        page.check("estimate_assemblies_#{@assemblies[2].id.to_s}")
        page.fill_in "estimate_components_#{@assembly_components[12].assembly.id.to_s}_#{@assembly_components[12].component.id.to_s}", :with => '0'
        # save_and_open_page
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      page.should have_selector(:xpath, "//td[contains(@class, 'warning') and @id='grand_totals_type_2']")
      visit edit_estimate_path (estimate.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      page.should have_selector(:xpath, "//td[contains(@class, 'warning') and @id='grand_totals_type_2']")
    end
    it 'should give no warning when hours are converted' do
      all_attribs = @estimate_attributes
      estimate = Estimate.create!(@estimate_attributes)
      Estimate.count.should == 1
      estimate.deactivated?.should be_false
      visit edit_estimate_path (estimate.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      page.should have_selector(:xpath, "//input[@id=\"estimate_components_#{@assembly_components[12].assembly.id.to_s}_#{@assembly_components[12].component.id.to_s}\"]")
      page.should have_selector(:xpath, "//td[contains(@class, 'warning') and @id='grand_totals_type_2']")
      # find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[12].id.to_s}_total\"]").text.should =~ /^0.00$/
      # page.should have_selector(:xpath, "//span[@class='component_value required']/input[@id=\"estimate_components_#{@assembly_components[12].assembly.id.to_s}_#{@assembly_components[12].component.id.to_s}\"]")
      within(".edit_estimate") do
        # save_and_open_page
        # check assemblies so they are seen in show after update
        page.check("estimate_assemblies_#{@assemblies[0].id.to_s}")
        page.check("estimate_assemblies_#{@assemblies[1].id.to_s}")
        page.check("estimate_assemblies_#{@assemblies[2].id.to_s}")
        page.fill_in "estimate_components_#{@assembly_components[12].assembly.id.to_s}_#{@assembly_components[12].component.id.to_s}", :with => '25.00'
        # save_and_open_page
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      page.should_not have_selector(:xpath, "//td[contains(@class, 'warning') and @id='grand_totals_type_2']")
      page.should have_selector(:xpath, "//td[@id='grand_totals_type_2']")
      visit edit_estimate_path (estimate.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      page.should_not have_selector(:xpath, "//td[contains(@class, 'warning') and @id='grand_totals_type_2']")
      page.should have_selector(:xpath, "//td[@id='grand_totals_type_2']")
    end
    it 'should show default value next to label' do #, :js => true do # see VIEWS_SCRIPTING = false in spec_helper.rb
      # @defaults.each do |df|
      #   Rails.logger.debug("TXXXXXX default values = #{df.value.bd_to_s(2)}")
      # end
      all_attribs = @estimate_attributes
      estimate = Estimate.create!(@estimate_attributes)
      Estimate.count.should == 1
      estimate.deactivated?.should be_false
      visit edit_estimate_path (estimate.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      Rails.logger.debug("T estimates_integration_spec - @estimate_attributes = #{@estimate_attributes.inspect.to_s}")
      # following tests dependent upon helper_load_assemblies, spec_helper.rb helper_load_component_types and helper_load_components
      # 9th component type is not 'has_totals', so it is a regular component with a default value (note the not editable flag is ignored here)
      find(:xpath, "//input[@id=\"estimate_components_#{@assembly_total.id.to_s}_#{@assembly_components[9].component.id.to_s}\"]").value.should =~ /^#{@assembly_components[9].component.default.value.bd_to_s(2)}$/
      find(:xpath, "//input[@id=\"estimate_components_#{@assembly_total.id.to_s}_#{@assembly_components[9].component.id.to_s}\"]").value.should =~ /^#{@defaults[0].value.bd_to_s(2)}$/
      # 10th is editable and 'has_totals' (grid component), with no default value
      ac_10 = @assembly_components[10]
      # it 'should list operation on component descriptions for editable components'
      find(:xpath, "//td[@id=\"grid_label_#{ac_10.assembly_id.to_s}_#{@component_type_totals.id.to_s}_#{ac_10.component_id.to_s}\"]/label").text.should_not =~ /^#{ac_10.description}$/
      find(:xpath, "//td[@id=\"grid_label_#{ac_10.assembly_id.to_s}_#{@component_type_totals.id.to_s}_#{ac_10.component_id.to_s}\"]/label").text.should =~ /#{ac_10.description}.*#{ac_10.component.grid_scope} #{ac_10.component.grid_operand}/
      find(:xpath, "//input[@id=\"estimate_components_#{@assembly_components[10].assembly_id.to_s}_#{@assembly_components[10].component_id.to_s}\"]").value.should =~ /#{@assembly_components[10].component.default.value.bd_to_s(2)}/
      # 11th is not editable totals grid
      ac_11 = @assembly_components[11]
      # it 'should list operation on component descriptions for not editable components'
      find(:xpath, "//td[@id=\"grid_label_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[11].id.to_s}\"]", :text => "#{@assembly_components[11].description} ( I * #{ac_11.component.default.value.bd_to_s(2)})")
      find(:xpath, "//td[@id=\"grid_label_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[11].id.to_s}\"]", :text => "#{ac_11.description} ( #{ac_11.component.grid_scope} #{ac_11.component.grid_operand} #{ac_11.component.default.value.bd_to_s(2)})")
    end
    it 'should let user edit default value when editable in edit mode' do #, :js => true do # see VIEWS_SCRIPTING = false in spec_helper.rb
      all_attribs = @estimate_attributes
      estimate = Estimate.create!(@estimate_attributes)
      Estimate.count.should == 1
      estimate.deactivated?.should be_false
      visit edit_estimate_path (estimate.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      Rails.logger.debug("T estimates_integration_spec - @estimate_attributes = #{@estimate_attributes.inspect.to_s}")
      # following tests dependent upon helper_load_assemblies, spec_helper.rb helper_load_component_types and helper_load_components
      page.should have_selector(:xpath, "//label[@for=\"estimate_components_#{@assembly_components[10].assembly_id.to_s}_#{@assembly_components[10].component_id.to_s}\"]", :text => "#{@assembly_components[10].description}")
      page.should have_selector(:xpath, "//input[@id=\"estimate_components_#{@assembly_components[10].assembly_id.to_s}_#{@assembly_components[10].component_id.to_s}\"]") #, :text => "#{BIG_DECIMAL_ZERO.bd_to_s(2)}")
      within(".edit_estimate") do
        page.fill_in "estimate_components_#{@assembly_components[10].assembly_id.to_s}_#{@assembly_components[10].component_id.to_s}", :with => 987.65
        # save_and_open_page
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      @updated_item = Estimate.find(estimate.id)
      find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~ /^#{I18n.translate('errors.warn_method_obj_name_warn', :method => 'update', :obj => 'Estimate', :name => estimate.desc, :warn => I18n.translate('error_messages.missing_required_field') )}$/
      find(:xpath, "//td[@id=\"grid_label_#{@assembly_components[10].assembly_id.to_s}_#{@component_type_totals.id.to_s}_#{@assembly_components[10].component_id.to_s}\"]").text.should =~ /#{@assembly_components[10].description}.*(987.65)/  # note wildcard to handle space ???      
    end
    it 'should accumulate component totals to component types and assemblies' do #, :js => true do # see VIEWS_SCRIPTING = false in spec_helper.rb
      all_attribs = @estimate_attributes
      estimate = Estimate.create!(@estimate_attributes)
      Estimate.count.should == 1
      estimate.deactivated?.should be_false
      visit edit_estimate_path (estimate.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      Rails.logger.debug("T estimates_integration_spec - @estimate_attributes = #{@estimate_attributes.inspect.to_s}")
      # following tests dependent upon helper_load_assemblies, spec_helper.rb helper_load_component_types and helper_load_components
      within(".edit_estimate") do
        # save_and_open_page      
        page.check("estimate_assemblies_#{@assemblies[1].id.to_s}")
        # find("#assembly_#{@assemblies[1].id.to_s}/h3").click
        page.fill_in "estimate_components_#{@assemblies[0].id.to_s}_#{@components[0].id.to_s}", :with => '2.34'
        # it 'should not list deactivate components'
        page.should_not have_selector(:xpath, "//input[@id=\"estimate_components_#{@assemblies[1].id.to_s}_#{@component_deact.id.to_s}\"]")
        page.should_not have_selector(:xpath, "//input[@id=\"estimate_components_#{@assembly_component_deact1.assembly_id.to_s}_#{@assembly_component_deact1.component_id.to_s}\"]")
        # page.fill_in "estimate_components_#{@assemblies[1].id.to_s}_#{@components[0].id.to_s}", :with => '3.45'
        page.fill_in "estimate_components_#{@assemblies[1].id.to_s}_#{@components[1].id.to_s}", :with => '4.56'
        page.fill_in "estimate_components_#{@assemblies[1].id.to_s}_#{@components[2].id.to_s}", :with => '5.67'
        page.fill_in "estimate_components_#{@assembly_all.id.to_s}_#{@components[3].id.to_s}", :with => '6.78'
        page.fill_in "estimate_components_#{@assembly_all.id.to_s}_#{@components[4].id.to_s}", :with => '7.89'
        # it 'should not list components with deactivated component types'
        page.should_not have_selector(:xpath, "//input[@id=\"estimate_components_#{@assembly_all.id.to_s}_#{@components[5].id.to_s}\"]")
        page.should_not have_selector(:xpath, "//input[@id=\"estimate_components_#{@assembly_component_deact2.assembly_id.to_s}_#{@assembly_component_deact2.component_id.to_s}\"]")
        page.should_not have_selector(:xpath, "//span[@id=\"component_type_#{@assembly_all.id.to_s}_#{@component_types[2].id.to_s}\"]")        
        page.fill_in "estimate_components_#{@assembly_all.id.to_s}_#{@components[6].id.to_s}", :with => '9.01'
        page.fill_in "estimate_components_#{@assembly_all.id.to_s}_#{@components[7].id.to_s}", :with => '1.34'
        page.fill_in "estimate_components_#{@assembly_total.id.to_s}_#{@components[9].id.to_s}", :with => '2.45'
        page.fill_in "estimate_components_#{@assembly_total.id.to_s}_#{@assembly_components[10].component_id.to_s}", :with => 2.5
        # it 'should not list deactivated assembly_components'
        page.should_not have_selector(:xpath, "//input[@id=\"estimate_components_#{@assembly_component_deact3.assembly_id.to_s}_#{@assembly_component_deact3.component_id.to_s}\"]")
        # save_and_open_page      
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.should_not have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      page.should_not have_selector(:xpath, '//*', :text => 'translation missing:')
      page.should_not have_selector(:xpath, "//div[@id=\"assembly_#{@assemblies[0].id.to_s}\"]")
      page.should have_selector(:xpath, "//div[@id=\"assembly_#{@assemblies[1].id.to_s}\"]")
     # if these dont match, first check 'should list the components for the selected estimate assemblies in new/create view after create' to make sure that entries and totals are correc
      # it 'should not list components with unchecked assemblies'
      page.should_not have_selector(:xpath, "//span[@id=\"estimate_components_#{@assemblies[0].id.to_s}_#{@components[0].id.to_s}\"]")
      # it 'should not list deactivated components'
      page.should_not have_selector(:xpath, "//span[@id=\"estimate_components_#{@assemblies[1].id.to_s}_#{@component_deact.id.to_s}\"]")
      find(:xpath, "//span[@id=\"estimate_components_#{@assemblies[1].id.to_s}_#{@components[1].id.to_s}\"]").text.should =~ /4.56/
      find(:xpath, "//span[@id=\"estimate_components_#{@assemblies[1].id.to_s}_#{@components[2].id.to_s}\"]").text.should =~ /5.67/
      find(:xpath, "//span[@id=\"component_type_total_#{@assemblies[1].id.to_s}_#{@component_types[1].id.to_s}\"]").text.should =~ /10.23/
      # dont add hours into totals
      find(:xpath, "//td[@id=\"assembly_component_type_totals_#{@assemblies[1].id.to_s}_total\"]").text.should =~/^0.00$/
      find(:xpath, "//span[@id=\"estimate_components_#{@assembly_all.id.to_s}_#{@components[3].id.to_s}\"]").text.should =~ /6.78/
      find(:xpath, "//span[@id=\"component_type_total_#{@assembly_all.id.to_s}_#{@component_types[0].id.to_s}\"]").text.should =~ /6.78/
      find(:xpath, "//span[@id=\"estimate_components_#{@assembly_all.id.to_s}_#{@components[4].id.to_s}\"]").text.should =~ /7.89/
      find(:xpath, "//span[@id=\"component_type_total_#{@assembly_all.id.to_s}_#{@component_types[1].id.to_s}\"]").text.should =~ /7.89/
      # it 'should not list components with deactivated component types'
      page.should_not have_selector(:xpath, "//span[@id=\"estimate_components_#{@assembly_all.id.to_s}_#{@components[5].id.to_s}\"]")
      page.should_not have_selector(:xpath, "//span[@id=\"component_type_#{@assembly_all.id.to_s}_#{@component_types[2].id.to_s}\"]")        
      find(:xpath, "//span[@id=\"estimate_components_#{@assembly_all.id.to_s}_#{@components[6].id.to_s}\"]").text.should =~ /9.01/
      find(:xpath, "//span[@id=\"estimate_components_#{@assembly_all.id.to_s}_#{@components[7].id.to_s}\"]").text.should =~ /1.34/
      find(:xpath, "//span[@id=\"component_type_total_#{@assembly_all.id.to_s}_#{@component_types[3].id.to_s}\"]").text.should =~ /10.35/
      find(:xpath, "//td[@id=\"assembly_component_type_totals_#{@assembly_all.id.to_s}_total\"]").text.should =~/^17.13$/
      find(:xpath, "//span[@id=\"estimate_components_#{@assembly_total.id.to_s}_#{@components[9].id.to_s}\"]").text.should =~ /2.45/
      find(:xpath, "//span[@id=\"component_type_total_#{@assembly_total.id.to_s}_#{@component_types[0].id.to_s}\"]").text.should =~ /2.45/
      # find(:xpath, "//span[@id=\"component_type_total_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}\"]").text.should =~ /42.61/
      find(:xpath, "//td[@id=\"component_type_total_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_total\"]").text.should =~ /42.61/
      find(:xpath, "//td[@id=\"assembly_component_type_totals_#{@assembly_total.id.to_s}_total\"]").text.should =~/^45.06$/
      # grand totals
      # find(:xpath, "//span[@id=\"grand_total\"]").text.should =~ /80.31/
      find(:xpath, "//td[@id=\"grand_totals_type_total\"]").text.should =~ /^62.19$/  # note unconverted hours difference
    end
    it 'should perform the component operation for each column' do #, :js => true do # see VIEWS_SCRIPTING = false in spec_helper.rb
      all_attribs = @estimate_attributes
      estimate = Estimate.create!(@estimate_attributes)
      Estimate.count.should == 1
      estimate.deactivated?.should be_false
      visit edit_estimate_path (estimate.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      Rails.logger.debug("T estimates_integration_spec - @estimate_attributes = #{@estimate_attributes.inspect.to_s}")
      # following tests dependent upon helper_load_assemblies, spec_helper.rb helper_load_component_types and helper_load_components
      within(".edit_estimate") do
        # check assemblies so they are seen in show after update
        # page.check("estimate_assemblies_#{@assemblies[0].id.to_s}")
        page.check("estimate_assemblies_#{@assemblies[1].id.to_s}")
        # page.check("estimate_assemblies_#{@assemblies[2].id.to_s}")
        # find("#assembly_#{@assemblies[1].id.to_s}/h3").click
        page.fill_in "estimate_components_#{@assemblies[0].id.to_s}_#{@components[0].id.to_s}", :with => '2.34'
        # it 'should not list deactivate components'
        page.should_not have_selector(:xpath, "//input[@id=\"estimate_components_#{@assemblies[1].id.to_s}_#{@components[0].id.to_s}\"]")
        # page.fill_in "estimate_components_#{@assemblies[1].id.to_s}_#{@components[0].id.to_s}", :with => '3.45'
        page.fill_in "estimate_components_#{@assemblies[1].id.to_s}_#{@components[1].id.to_s}", :with => '4.56'
        page.fill_in "estimate_components_#{@assemblies[1].id.to_s}_#{@components[2].id.to_s}", :with => '5.67'
        page.fill_in "estimate_components_#{@assembly_all.id.to_s}_#{@components[3].id.to_s}", :with => '6.78'
        page.fill_in "estimate_components_#{@assembly_all.id.to_s}_#{@components[4].id.to_s}", :with => '7.89'
        # it 'should not list components with deactivated component types'
        page.should_not have_selector(:xpath, "//input[@id=\"estimate_components_#{@assembly_all.id.to_s}_#{@components[5].id.to_s}\"]")
        page.should_not have_selector(:xpath, "//span[@id=\"component_type_#{@assembly_all.id.to_s}_#{@component_types[2].id.to_s}\"]")        
        page.fill_in "estimate_components_#{@assembly_all.id.to_s}_#{@components[6].id.to_s}", :with => '9.01'
        page.fill_in "estimate_components_#{@assembly_all.id.to_s}_#{@components[7].id.to_s}", :with => '1.34'
        page.fill_in "estimate_components_#{@assembly_total.id.to_s}_#{@components[9].id.to_s}", :with => '2.45'
        page.fill_in "estimate_components_#{@assembly_total.id.to_s}_#{@assembly_components[10].component_id.to_s}", :with => 2.5
        page.fill_in "estimate_components_#{@assembly_total.id.to_s}_#{@assembly_components[12].component_id.to_s}", :with => 3.0
        page.fill_in "estimate_components_#{@assembly_total.id.to_s}_#{@assembly_components[13].component_id.to_s}", :with => 3.5
        page.fill_in "estimate_components_#{@assembly_total.id.to_s}_#{@assembly_components[14].component_id.to_s}", :with => 4.0
        page.fill_in "estimate_components_#{@assembly_total.id.to_s}_#{@assembly_components[15].component_id.to_s}", :with => 4.5
        # page.fill_in "estimate_components_#{@assembly_total.id.to_s}_#{@assembly_components[16].component_id.to_s}", :with => 5.0
        page.fill_in "estimate_components_#{@assembly_total.id.to_s}_#{@assembly_components[17].component_id.to_s}", :with => 5.0
        # save_and_open_page
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      # confirm that calculations work
      # check to confirm initial cumulative Totals for grid are correct
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}___#{@component_types[0].id.to_s}\"]").text.should =~/^6.78$/
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}___#{@component_types[1].id.to_s}\"]").text.should =~/^18.12$/
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}___#{@component_types[4].id.to_s}\"]").text.should =~/^0.00$/
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}___total\"]").text.should =~/^6.78$/
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}__#{@component_types[0].id.to_s}\"]").text.should =~/^9.23$/
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}__#{@component_types[1].id.to_s}\"]").text.should =~/^18.12$/
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}__#{@component_types[4].id.to_s}\"]").text.should =~/^0.00$/
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}__total\"]").text.should =~/^9.23$/
      # "One" Sub-totals Group
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[10].id.to_s}_#{@component_types[0].id.to_s}\"]").text.should =~ /.*= 16.95$/
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[10].id.to_s}_#{@component_types[1].id.to_s}\"]").text.should =~ /^0.00$/ # zero because not an hourly operation
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[10].id.to_s}_total\"]").text.should =~ /^16.95$/
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[11].id.to_s}_#{@component_types[0].id.to_s}\"]").text.should =~ /.*= 25.66$/
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[11].id.to_s}_#{@component_types[1].id.to_s}\"]").text.should =~ /^0.00$/ # zero because not an hourly operation
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[11].id.to_s}_total\"]").text.should =~ /^25.66$/
      # it 'should show "subtotal one" at break in grid_subtotal in components'
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_stot_1_#{@component_types[0].id.to_s}\"]").text.should =~/^42.61$/
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_stot_1_#{@component_types[1].id.to_s}\"]").text.should =~/^0.00$/
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_stot_1_#{@component_types[4].id.to_s}\"]").text.should =~/^0.00$/
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_stot_1_total\"]").text.should =~/^42.61$/
      # "two" Sub-totals Group
      # it 'should perform hourly operations only on hourly component types'
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[12].id.to_s}_#{@component_types[0].id.to_s}\"]").text.should =~ /^0.00$/
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[12].id.to_s}_#{@component_types[1].id.to_s}\"]").text.should =~ /.*= 54.36$/
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[12].id.to_s}_total\"]").text.should =~ /^54.36$/
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[13].id.to_s}_#{@component_types[0].id.to_s}\"]").text.should =~ /.*= 149.13$/
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[13].id.to_s}_#{@component_types[1].id.to_s}\"]").text.should =~ /.*= 0.00$/
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[13].id.to_s}_total\"]").text.should =~ /^149.13$/
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[14].id.to_s}_#{@component_types[0].id.to_s}\"]").text.should =~ /.*= 0.00$/
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[14].id.to_s}_#{@component_types[1].id.to_s}\"]").text.should =~ /.*= 0.00$/
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[14].id.to_s}_total\"]").text.should =~ /^0.00$/
      # it 'should not perform non-hourly operations on hourly component types'
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[15].id.to_s}_#{@component_types[0].id.to_s}\"]").text.should =~ /^.*= 191.74$/
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[15].id.to_s}_#{@component_types[1].id.to_s}\"]").text.should =~ /^0.00$/
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[15].id.to_s}_total\"]").text.should =~ /^191.74$/
      # it 'should show "subtotal two" at break in grid_subtotal in components'
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_stot_2_#{@component_types[0].id.to_s}\"]").text.should =~/^340.88$/
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_stot_2_#{@component_types[1].id.to_s}\"]").text.should =~/^54.36$/
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_stot_2_#{@component_types[4].id.to_s}\"]").text.should =~/^0.00$/
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_stot_2_total\"]").text.should =~/^395.24$/
      # start of the "three" Sub-total Group
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[17].id.to_s}_#{@component_types[0].id.to_s}\"]").text.should =~ /.*= 0.34$/
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[17].id.to_s}_#{@component_types[1].id.to_s}\"]").text.should =~ /.*= 0.91$/
      find(:xpath, "//td[@id=\"grid_calc_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@components[17].id.to_s}_total\"]").text.should =~ /^1.25$/
      # it 'should show subtotals at break in grid_subtotal in components'
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_stot_3_#{@component_types[0].id.to_s}\"]").text.should =~/^0.34$/
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_stot_3_#{@component_types[1].id.to_s}\"]").text.should =~/^0.91$/
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_stot_3_#{@component_types[4].id.to_s}\"]").text.should =~/^0.00$/
      find(:xpath, "//td[@id=\"subtotal_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_stot_3_total\"]").text.should =~/^1.25$/
      # show assembly total component type totals
      find(:xpath, "//td[@id=\"component_type_total_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@component_types[0].id.to_s}\"]").text.should =~/^383.82$/
      find(:xpath, "//td[@id=\"component_type_total_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@component_types[1].id.to_s}\"]").text.should =~/^55.27$/
      find(:xpath, "//td[@id=\"component_type_total_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_#{@component_types[4].id.to_s}\"]").text.should =~/^0.00$/
      find(:xpath, "//td[@id=\"component_type_total_#{@assembly_total.id.to_s}_#{@component_type_totals.id.to_s}_total\"]").text.should =~/^439.09$/
      # show assembly totals (including component types not in_totals_grid)
      find(:xpath, "//td[@id=\"assembly_component_type_totals_#{@assembly_total.id.to_s}_#{@component_types[0].id.to_s}\"]").text.should =~/^386.27$/
      find(:xpath, "//td[@id=\"assembly_component_type_totals_#{@assembly_total.id.to_s}_#{@component_types[1].id.to_s}\"]").text.should =~/^55.27$/
      find(:xpath, "//td[@id=\"assembly_component_type_totals_#{@assembly_total.id.to_s}_#{@component_types[3].id.to_s}\"]").text.should =~/^0.00$/
      find(:xpath, "//td[@id=\"assembly_component_type_totals_#{@assembly_total.id.to_s}_#{@component_types[4].id.to_s}\"]").text.should =~/^0.00$/
      find(:xpath, "//td[@id=\"assembly_component_type_totals_#{@assembly_total.id.to_s}_total\"]").text.should =~/^441.54$/
    end
  end
  
end
