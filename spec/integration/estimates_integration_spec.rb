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
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('estimates.show.header')}$/
      page.should_not have_selector(:xpath, '//*', :text => 'translation missing:')
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ 
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => item1.class.name, :id => item1.id )}$/
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
      # item2 = Estimate.create!(FactoryGirl.attributes_for(:estimate))
      visit estimates_path()
      # save_and_open_page
      page.should_not have_selector(:xpath, '//*', :text => 'translation missing:')
    end
    it 'should not be found on list page' do
      item1 = Estimate.create!(@estimate_attributes)
      # item2 = Estimate.create!(FactoryGirl.attributes_for(:estimate))
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
end
