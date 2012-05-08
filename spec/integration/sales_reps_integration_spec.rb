# spec/integration/sales_reps_integration_spec.rb

require 'spec_helper'
include UserIntegrationHelper
include ApplicationHelper

describe 'SalesReps Integration Tests' do

  before(:each) do
    @user1 = User.create!(FactoryGirl.attributes_for(:user_create))
    @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
    helper_signin(:admin_user_full_create_attr, @me.full_name)
    visit home_index_path
    Rails.logger.debug("T sales_reps_integration_spec Admin item logged in before - done")
  end
  context 'it should have crud actions available and working' do
    it "should create a new item with parent association specified" do
      num_items = SalesRep.count
      num_items.should == 0
      visit new_sales_rep_path()
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      attribs = FactoryGirl.attributes_for(:sales_rep_create, user: @user1)
      Rails.logger.debug("T sales_reps_integration_spec - attribs = #{attribs.inspect.to_s}")
      within(".new_sales_rep") do
        page.select @user1.username, :from => 'sales_rep_user_id'
        page.fill_in 'sales_rep_min_markup_pct', :with => attribs[:min_markup_pct]
        page.fill_in 'sales_rep_max_markup_pct', :with => attribs[:max_markup_pct]
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.show.header')}$/
      page.should_not have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      # find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\Z/  # be whitespace
      find(:xpath, '//*[@id="sales_rep_min_markup_pct"]').text.should =~ /^#{attribs[:min_markup_pct]}/  # be new value
      find(:xpath, '//*[@id="sales_rep_max_markup_pct"]').text.should =~ /^#{attribs[:max_markup_pct]}/  # be new value
      num_items.should == SalesRep.count - 1
    end
    it "should not create a new item without parent association specified" do
      num_items = SalesRep.count
      num_items.should == 0
      visit new_sales_rep_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page
      attribs = FactoryGirl.attributes_for(:sales_rep_create, user: @user1)
      Rails.logger.debug("T sales_reps_integration_spec - attribs = #{attribs.inspect.to_s}")
      within(".new_sales_rep") do
        # page.select @user1.username, :from => 'sales_rep_user_id'
        page.fill_in 'sales_rep_min_markup_pct', :with => attribs[:min_markup_pct]
        page.fill_in 'sales_rep_max_markup_pct', :with => attribs[:max_markup_pct]
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.new.header')}$/
      page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      # find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should_not =~ /\A\s*\Z$/  # be whitespace
      # find(:xpath, '//input[@id="sales_rep_description"]').value.should =~ /#{attribs[:description]}/  # be new value
      find(:xpath, '//input[@id="sales_rep_min_markup_pct"]').value.should =~ /^#{attribs[:min_markup_pct]}/  # be new value
      find(:xpath, '//input[@id="sales_rep_max_markup_pct"]').value.should =~ /^#{attribs[:max_markup_pct]}/  # be new value
      num_items.should == SalesRep.count
    end
    it "should not see users in user select listing that already have a sales rep assigned" do
      #
      # create a salesrep for @user1
      #
      num_items = SalesRep.count
      num_items.should == 0
      visit new_sales_rep_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page
      attribs = FactoryGirl.attributes_for(:sales_rep_create, user: @user1)
      Rails.logger.debug("T sales_reps_integration_spec - attribs = #{attribs.inspect.to_s}")
      within(".new_sales_rep") do
        page.select @user1.username, :from => 'sales_rep_user_id'
        page.fill_in 'sales_rep_min_markup_pct', :with => attribs[:min_markup_pct]
        page.fill_in 'sales_rep_max_markup_pct', :with => attribs[:max_markup_pct]
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.show.header')}$/
      page.should_not have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      # find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\Z/  # be whitespace
      find(:xpath, '//*[@id="sales_rep_min_markup_pct"]').text.should =~ /^#{attribs[:min_markup_pct]}/  # be new value
      find(:xpath, '//*[@id="sales_rep_max_markup_pct"]').text.should =~ /^#{attribs[:max_markup_pct]}/  # be new value
      SalesRep.count.should == num_items + 1
      #
      # Try to create a salesrep for @user1 again
      #
      visit new_sales_rep_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page
      Rails.logger.debug("T sales_reps_integration_spec - attribs = #{attribs.inspect.to_s}")
      # should still see @me
      page.should have_selector(:xpath, "//select[@id=\"sales_rep_user_id\"]/option[@value=\"#{@me.id}\"]")
      # should no longer see @user1
      page.should_not have_selector(:xpath, "//select[@id=\"sales_rep_user_id\"]/option[@value=\"#{@user1.id}\"]")
      # page.select @user1.username, :from => 'sales_rep_user_id'
      SalesRep.count.should == num_items + 1
    end
    it 'should notify user when trying to create a user missing required fields' do
      item1 = FactoryGirl.create(:sales_rep_min_create, user: @user1)
      # dont do this if min size == 0
      Rails.logger.debug("T sales_reps_integration_spec #{FactoryGirl.attributes_for(:sales_rep_min_create).size}")
      if FactoryGirl.attributes_for(:sales_rep_min_create).size > 0
        num_items = SalesRep.count
        visit new_sales_rep_path()
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.new.header')}$/
        # save_and_open_page
        within(".new_sales_rep") do
          find(:xpath, '//input[@type="submit"]').click
        end
        # save_and_open_page
        page.driver.status_code.should be 200
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.new.header')}$/
        page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
        # find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\z/  # be whitespace
        page.should have_selector(:xpath, '//span[@class="field_with_errors"]')
        num_items.should == SalesRep.count
      end
    end
    it 'should be able to edit and update all of an items accessible fields' do
      all_attribs = generate_sales_rep_accessible_attributes(@user1)
      item1 = SalesRep.create(all_attribs)
      item1.deactivated?.should be_false
      visit edit_sales_rep_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.edit.header')}$/
      within(".edit_sales_rep") do
        all_attribs.each do | at_key, at_val |
          Rails.logger.debug("T sales_reps_integration_spec edit update - key-val:#{at_key.to_s}-#{at_val.to_s}")
          if at_val.is_a?(TrueClass)
            Rails.logger.debug("T sales_reps_integration_spec edit update - TrueClass")
            page.choose("sales_rep_#{at_key.to_s}_true")
            page.should have_selector(:xpath, "//*[@id=\"sales_rep_#{at_key.to_s}_true\" and @checked]")
          elsif at_val.is_a?(FalseClass)
            Rails.logger.debug("T sales_reps_integration_spec edit update - FalseClass")
            page.choose("sales_rep_#{at_key.to_s}_false")
            page.should have_selector(:xpath, "//*[@id=\"sales_rep_#{at_key.to_s}_false\" and @checked]")
          elsif at_val.is_a?(ActiveRecord::Base)
            Rails.logger.debug("T sales_reps_integration_spec edit update - Active Record Model - #{at_val.class.name}")
            page.select(at_val.username.to_s, :from => "sales_rep_#{at_key.to_s}")
            # page.should have_selector(:xpath, "//*[@id=\"sales_rep_#{at_key.to_s}\"]", :value => at_val.id.to_s)
          else
            # simply fill in the field
            Rails.logger.debug("T sales_reps_integration_spec edit update - other class")
            page.fill_in "sales_rep_#{at_key.to_s}", :with => at_val
          end
        end
        # save_and_open_page
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.show.header')}$/
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => item1.class.name, :id => item1.id )}$/
      all_attribs.each do | at_key, at_val |
        Rails.logger.debug("T sales_reps_integration_spec edit updated show - key-val:#{at_key.to_s}-#{at_val.to_s}")
        if at_key.to_s == 'deactivated'
          Rails.logger.debug("T sales_reps_integration_spec edit updated show - deactivated")
          find(:xpath, "//*[@id=\"sales_rep_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/
        elsif at_val.is_a?(TrueClass)
          Rails.logger.debug("T sales_reps_integration_spec edit updated show #{at_key.to_s} - TrueClass")
          find(:xpath, "//*[@id=\"sales_rep_#{at_key.to_s}\"]").text.should =~ /^true$/
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T sales_reps_integration_spec edit updated show #{at_key.to_s} - FalseClass")
          find(:xpath, "//*[@id=\"sales_rep_#{at_key.to_s}\"]").text.should =~ /^false$/
        elsif at_val.is_a?(ActiveRecord::Base)
          Rails.logger.debug("T sales_reps_integration_spec edit updated show - Active Record Model - #{at_val.class.name}")
          page.should have_selector(:xpath, "//*[@id=\"sales_rep_#{at_val.class.name.downcase}\"]", :value => at_val.last_name.nil_to_s+', '+at_val.first_name.nil_to_s)
        else
          Rails.logger.debug("T sales_reps_integration_spec edit updated show #{at_key.to_s} - #{at_val.to_s} - other")
          find(:xpath, "//*[@id=\"sales_rep_#{at_key.to_s}\"]").text.should =~ /^#{at_val.to_s}$/
        end
      end
      updated_item = SalesRep.find(item1.id)
      all_attribs.each do | at_key, at_val |
        if at_val.is_a?(ActiveRecord::Base)
          updated_item.send(at_key.to_s).should == at_val.id
        else
          updated_item.send(at_key.to_s).should == at_val
        end
      end
    end
    it 'should be able to show all accessible fields of an item' do
      all_attribs = FactoryGirl.attributes_for(:sales_rep_accessible)
      item1 = FactoryGirl.create(:sales_rep_accessible_create, user: @user1)
      item1.deactivated?.should be_true
      # visit (sales_rep_path, item1, :show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      visit "/sales_reps/#{item1.id}?show_deactivated=true" # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.show.header')}$/
      all_attribs.each do | at_key, at_val |
        if at_key.to_s == 'deactivated'
          Rails.logger.debug("T sales_reps_integration_spec edit updated show - deactivated")
          find(:xpath, "//*[@id=\"sales_rep_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/
        elsif at_val.is_a?(TrueClass)
          Rails.logger.debug("T sales_reps_integration_spec edit updated show #{at_key.to_s} - TrueClass")
          find(:xpath, "//*[@id=\"sales_rep_#{at_key.to_s}\"]").text.should =~ /^true$/
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T sales_reps_integration_spec edit updated show #{at_key.to_s} - FalseClass")
          find(:xpath, "//*[@id=\"sales_rep_#{at_key.to_s}\"]").text.should =~ /^false$/
        else
          find(:xpath, "//*[@id=\"sales_rep_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s}\z/
        end
      end
    end
  end

  context 'sales_rep layouts - ' do
    before(:each) do
      @item1 = FactoryGirl.create(:sales_rep_min_create, user: @user1)
    end
    context 'Header Show/Hide Deactivated links - ' do
      it 'should send index page with correct show/hide link in table header' do
        visit sales_reps_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
        page.should have_selector(:xpath, "//th/a", :text =>  I18n.translate('view_action.hide_deactivated') )
        # hide deactivated records
        find(:xpath, "//th/a", :text =>  I18n.translate('view_action.hide_deactivated') ).click
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
        page.should have_selector(:xpath, "//th/a", :text =>  I18n.translate('view_action.show_deactivated') )
        # show deactivated records
        find(:xpath, "//th/a", :text =>  I18n.translate('view_action.show_deactivated') ).click
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
        page.should have_selector(:xpath, "//th/a", :text =>  I18n.translate('view_action.hide_deactivated') )
      end
      it 'should send list page with correct show/hide link in table header' do
        visit list_sales_reps_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.list.header')}$/
        page.should have_selector(:xpath, "//th/a", :text =>  I18n.translate('view_action.hide_deactivated') )
        # hide deactivated records
        find(:xpath, "//th/a", :text =>  I18n.translate('view_action.hide_deactivated') ).click
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.list.header')}$/
        page.should have_selector(:xpath, "//th/a", :text =>  I18n.translate('view_action.show_deactivated') )
        # show deactivated records
        find(:xpath, "//th/a", :text =>  I18n.translate('view_action.show_deactivated') ).click
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.list.header')}$/
        page.should have_selector(:xpath, "//th/a", :text =>  I18n.translate('view_action.hide_deactivated') )
      end
    end
    context 'should have index/list row links working' do
      before(:each) do
        visit sales_reps_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
        page.should have_selector(:xpath, "//tr[@id=\"sales_rep_#{@item1.id}\"]/td/a", :text =>  I18n.translate('view_action.view') )
        page.should have_selector(:xpath, "//tr[@id=\"sales_rep_#{@item1.id}\"]/td/a", :text =>  I18n.translate('view_action.edit') )
      end
      it 'has clickable show button' do
        find(:xpath, "//tr[@id=\"sales_rep_#{@item1.id}\"]/td/a", :text =>  I18n.translate('view_action.view') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.show.header')}$/
      end
      it 'has clickable edit button' do
        find(:xpath, "//tr[@id=\"sales_rep_#{@item1.id}\"]/td/a", :text =>  I18n.translate('view_action.edit') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.edit.header')}$/
      end
    end
    # User is not really a parent here - is really a simple foreign key lookup
    # context 'should have index parent links working' do
    #   before(:each) do
    #     visit sales_reps_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
    #     save_and_open_page
    #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
    #     page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/h3/a", :text => "#{@item1.sales_rep_type.nil_to_s}" )
    #     page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  "New #{@item1.sales_rep_type.nil_to_s} SalesRep" )
    #   end
    #   it 'has clickable parent view link' do
    #     find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/h3/a", :text => "#{@item1.sales_rep_type.nil_to_s}" ).click
    #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('users.show.header')}$/
    #   end
    #   it 'has clickable parent new child button' do
    #     find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  "New #{@item1.sales_rep_type.nil_to_s} SalesRep" ).click
    #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.new.header')}$/
    #   end
    # end
    context 'should have index links working' do
      before(:each) do
        visit sales_reps_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('sales_reps.new.action') )
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('sales_reps.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.new.header')}$/
      end
    end
    context 'should have list links working' do
      before(:each) do
        visit list_sales_reps_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.list.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('sales_reps.new.action') )
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('sales_reps.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.new.header')}$/
      end
    end
    # no main menu here - list and index are the same
    # context 'should have menu links working' do
    #   before(:each) do
    #     visit sales_reps_menu_path()
    #     # save_and_open_page
    #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.menu.header')}$/
    #     page.should have_selector(:xpath, "//span[@id='index_action']/a", :text => I18n.translate('sales_reps.index.action') )
    #     page.should have_selector(:xpath, "//span[@id='list_action']/a", :text => I18n.translate('sales_reps.list.action') )
    #   end
    #   it 'has clickable index link' do
    #     find(:xpath, "//span[@id='index_action']/a", :text => I18n.translate('sales_reps.index.action') ).click
    #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
    #   end
    #   it 'has clickable list link' do
    #     find(:xpath, "//span[@id='list_action']/a", :text => I18n.translate('sales_reps.list.action') ).click
    #     find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.list.header')}$/
    #   end
    # end
    context 'should have new/create links working' do
      before(:each) do
        visit new_sales_rep_path()
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.new.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('sales_reps.index.action') )
      end
      it 'has clickable index link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('sales_reps.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
      end
    end
    context 'should have edit/update links working' do
      before(:each) do
        visit edit_sales_rep_path(@item1.id)
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.edit.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('sales_reps.show.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('sales_reps.index.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('sales_reps.list.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('sales_reps.new.action') )
      end
      it 'has clickable show button' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('sales_reps.show.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.show.header')}$/
      end
      it 'has clickable index link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('sales_reps.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
      end
      it 'has clickable list link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('sales_reps.list.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.list.header')}$/
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('sales_reps.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.new.header')}$/
      end
    end
    context 'should have show links working' do
      before(:each) do
        visit sales_rep_path(@item1.id)
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.show.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('sales_reps.edit.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('sales_reps.index.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('sales_reps.list.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('sales_reps.new.action') )
      end
      it 'has clickable edit button' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('sales_reps.edit.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.edit.header')}$/
      end
      it 'has clickable index link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('sales_reps.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
      end
      it 'has clickable list link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('sales_reps.list.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.list.header')}$/
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('sales_reps.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.new.header')}$/
      end
    end
  end
  context 'it should have deactivated actions available and working' do
    it 'should be able to list all items when show_deactivated is set' do
      item1 = FactoryGirl.create(:sales_rep_min_create, user: @user1)
      item1.deactivated?.should be_false
      user2 = FactoryGirl.create(:user_create)
      item_deact = FactoryGirl.create(:sales_rep_accessible_create, user: user2)
      item_deact.deactivated?.should be_true
      visit sales_reps_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
      find(:xpath, "//tr[@id=\"sales_rep_#{item1.id}\"]/td[@id=\"sales_rep_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      # find(:xpath, "(//tr[@id=\"sales_rep_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"sales_rep_#{item1.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
      find(:xpath, "//tr[@id=\"sales_rep_#{item_deact.id}\"]/td[@id=\"sales_rep_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      # find(:xpath, "(//tr[@id=\"sales_rep_#{item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      find(:xpath, "//tr[@id=\"sales_rep_#{item_deact.id}\"]").should have_selector(:xpath, "td/a", :text => "#{I18n.translate('view_action.reactivate')}")
      find(:xpath, "//tr[@id=\"sales_rep_#{item_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
    end
    it 'should be able to list only active items when show_deactivated is off' do
      item1 = FactoryGirl.create(:sales_rep_min_create, user: @user1)
      item1.deactivated?.should be_false
      user2 = FactoryGirl.create(:user_create)
      item_deact = FactoryGirl.create(:sales_rep_accessible_create, user: user2)
      visit sales_reps_path(:show_deactivated => DB_FALSE.to_s) # dont show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
      page.should have_selector(:xpath, "//tr[@id=\"sales_rep_#{item1.id}\"]")
      page.should_not have_selector(:xpath, "//tr[@id=\"sales_rep_#{item_deact.id}\"]")
    end
    it 'should not see deactivate option on a deactivated item' do
      item_deact = FactoryGirl.create(:sales_rep_accessible_create, user: @user1)
      visit sales_reps_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
      find(:xpath, "//tr[@id=\"sales_rep_#{item_deact.id}\"]/td[@id=\"sales_rep_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "//tr[@id=\"sales_rep_#{item_deact.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.reactivate')}\"]")
      find(:xpath, "//tr[@id=\"sales_rep_#{item_deact.id}\"]").should_not have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
    end
    it 'should not see reactivate option on an active item' do
      item_active = FactoryGirl.create(:sales_rep_min_create, user: @user1)
      visit sales_reps_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
      find(:xpath, "//tr[@id=\"sales_rep_#{item_active.id}\"]/td[@id=\"sales_rep_#{item_active.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "//tr[@id=\"sales_rep_#{item_active.id}\"]").should_not have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.reactivate')}\"]")
      find(:xpath, "//tr[@id=\"sales_rep_#{item_active.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
    end
    it 'should not see delete on an active item' do
      item_active = FactoryGirl.create(:sales_rep_min_create, user: @user1)
      visit sales_reps_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
      find(:xpath, "//tr[@id=\"sales_rep_#{item_active.id}\"]/td[@id=\"sales_rep_#{item_active.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "//tr[@id=\"sales_rep_#{item_active.id}\"]").should_not have_selector(:xpath, "td/a[@data-method=\"delete\"]")
    end
    it 'should see delete on a deactivated item' do
      item_deact = FactoryGirl.create(:sales_rep_accessible_create, user: @user1)
      visit sales_reps_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
      find(:xpath, "//tr[@id=\"sales_rep_#{item_deact.id}\"]/td[@id=\"sales_rep_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "//tr[@id=\"sales_rep_#{item_deact.id}\"]").should have_selector(:xpath, "td/a[@data-method=\"delete\"]")
    end
    it 'should GET show the active item as not deactivated' do
      item1 = FactoryGirl.create(:sales_rep_min_create, user: @user1)
      item1.deactivated?.should be_false
      visit sales_rep_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.show.header')}$/
      find(:xpath, '//*[@id="sales_rep_deactivated"]').text.should_not =~ /\A\s*\z/
      find(:xpath, '//*[@id="sales_rep_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    end
    it 'should see the deactivated field in edit' do
      item1 = FactoryGirl.create(:sales_rep_min_create, user: @user1)
      item1.deactivated?.should be_false
      visit edit_sales_rep_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.edit.header')}$/
      page.should_not have_selector(:xpath, "//*[@id=\"sales_rep_deactivated_true\" and @checked]")
      page.should have_selector(:xpath, "//*[@id=\"sales_rep_deactivated_false\" and @checked]")
    end
    it 'controller should list items with deactivate/reactivate action/link/button depending upon status' do
      item1 = FactoryGirl.create(:sales_rep_min_create, user: @user1)
      item1.deactivated?.should be_false
      user2 = FactoryGirl.create(:user_create)
      @item_deact = FactoryGirl.create(:sales_rep_accessible_create, user: user2)
      SalesRep.count.should > 1
      visit sales_reps_path(:show_deactivated => DB_TRUE.to_s) # need to show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
      find(:xpath, "//tr[@id=\"sales_rep_#{item1.id}\"]/td[@id=\"sales_rep_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"sales_rep_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"sales_rep_#{@item_deact.id}\"]/td[@id=\"sales_rep_#{@item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "(//tr[@id=\"sales_rep_#{@item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      find(:xpath, "//tr[@id=\"sales_rep_#{@item_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
    end
    it 'Update action should allow a change from deactivated to active' do
      item1 = FactoryGirl.create(:sales_rep_min_create, user: @user1)
      item1.deactivated?.should be_false
      item1.deactivate
      @updated_item = SalesRep.find(item1.id)
      @updated_item.deactivated?.should be_true
      @num_items = SalesRep.count
      visit ("/sales_reps/#{item1.id}/edit?show_deactivated=true")
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.edit.header')}$/
      page.should have_selector(:xpath, "//*[@id=\"sales_rep_deactivated_true\" and @checked]")
      page.should_not have_selector(:xpath, "//*[@id=\"sales_rep_deactivated_false\" and @checked]")
      within(".edit_sales_rep") do
        page.choose("sales_rep_deactivated_false")
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('sales_reps.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => item1.class.name, :id => @updated_item.id )}/
      SalesRep.count.should == (@num_items)
      find(:xpath, "//*[@id=\"sales_rep_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      @updated_item = SalesRep.find(item1.id)
      @updated_item.deactivated?.should be_false
    end
    it 'Update action should allow a change from active to deactivated' do
      item1 = FactoryGirl.create(:sales_rep_min_create, user: @user1)
      item1.deactivated?.should be_false
      @num_items = SalesRep.count
      visit edit_sales_rep_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.edit.header')}$/
      page.should_not have_selector(:xpath, "//*[@id=\"sales_rep_deactivated_true\" and @checked]")
      page.should have_selector(:xpath, "//*[@id=\"sales_rep_deactivated_false\" and @checked]")
      within(".edit_sales_rep") do
        page.choose("sales_rep_deactivated_true")
        # select I18n.translate('view_field_value.deactivated'), :from => 'sales_rep_deactivated'
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => item1.class.name, :id => item1.id )}$/
      SalesRep.count.should == (@num_items)
      find(:xpath, "//*[@id=\"sales_rep_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      @updated_item = SalesRep.find(item1.id)
      @updated_item.deactivated?.should be_true
    end
    it 'should allow a item to be deactivated from the index page' do
      item1 = FactoryGirl.create(:sales_rep_min_create, user: @user1)
      item1.deactivated?.should be_false
      user2 = FactoryGirl.create(:user_create)
      @item_deact = FactoryGirl.create(:sales_rep_accessible_create, user: user2)
      @num_items = SalesRep.count
      @num_items.should > 1
      visit sales_reps_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
      find(:xpath, "//tr[@id=\"sales_rep_#{item1.id}\"]/td[@id=\"sales_rep_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"sales_rep_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"sales_rep_#{item1.id}\"]//a", :text => I18n.translate('view_action.deactivate') ).click
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'deactivate', :obj => item1.class.name, :id => item1.id )}$/
      SalesRep.count.should == (@num_items)
      @updated_item = SalesRep.find(item1.id)
      @updated_item.deactivated?.should be_true
    end
    it 'should allow a item to be reactivated from the index page' do
      item1 = FactoryGirl.create(:sales_rep_min_create, user: @user1)
      item1.deactivated?.should be_false
      user2 = FactoryGirl.create(:user_create)
      @item_deact = FactoryGirl.create(:sales_rep_accessible_create, user: user2)
      @num_items = SalesRep.count
      @num_items.should > 1
      visit sales_reps_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
      find(:xpath, "//tr[@id=\"sales_rep_#{@item_deact.id}\"]/td[@id=\"sales_rep_#{@item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.translate('view_field_value.deactivated')}\z/
      find(:xpath, "(//tr[@id=\"sales_rep_#{@item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      # click on reactivate button of deactivated item
      find(:xpath, "//tr[@id=\"sales_rep_#{@item_deact.id}\"]//a", :text => I18n.translate('view_action.reactivate') ).click
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'reactivate', :obj => item1.class.name, :id => @item_deact.id )}$/
      SalesRep.count.should == (@num_items)
      find(:xpath, "//*[@id=\"sales_rep_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      @updated_item = SalesRep.find(item1.id)
      @updated_item.deactivated?.should be_false
    end
    it 'should not list deactivated items by sales_rep_type' do
      item1 = FactoryGirl.create(:sales_rep_min_create, user: @user1)
      item1.deactivated?.should be_false
      user2 = FactoryGirl.create(:user_create)
      @item_deact = FactoryGirl.create(:sales_rep_accessible_create, user: user2)
      SalesRep.count.should > 1
      # get sales_reps_path
      # response.status.should be(200)
      visit sales_reps_path()
      page.driver.status_code.should be 200
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('sales_reps.index.header')}$/
      # find(:xpath, "//tr[@id=\"sales_rep_#{item1.id}\"]/td[@class=\"sales_rep_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"sales_rep_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      page.should_not have_selector(:xpath, "//tr[@id=\"sales_rep_#{@item_deact.id}\"]/td[@class=\"sales_rep_deactivated\"]", :text => I18n.is_deactivated_or_not(true) )
    end
  end
end
