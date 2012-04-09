# spec/integration/assemblies_integration_spec.rb

require 'spec_helper'
include UserIntegrationHelper
include ApplicationHelper

describe 'Assemblies Integration Tests' do

  before(:each) do
    @user1 = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
    @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
    helper_signin(:admin_user_full_create_attr, @me.full_name)
    visit home_index_path
    Rails.logger.debug("T assemblies_integration_spec Admin item logged in before - done")
  end
  context 'it should have crud actions available and working' do
    it "should create a new item" do
      num_items = Assembly.count
      visit new_assembly_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page      
      attribs = FactoryGirl.attributes_for(:assembly_create)
      Rails.logger.debug("T assemblies_integration_spec - attribs = #{attribs.inspect.to_s}")
      within(".new_assembly") do
        attribs.each do |at_key, at_value|
          if at_value.is_a?(TrueClass)
            page.choose("assembly_#{at_key.to_s}_true")
          elsif at_value.is_a?(FalseClass)
            page.choose("assembly_#{at_key.to_s}_false")
          else
            page.fill_in "assembly_#{at_key.to_s}", :with => at_value
          end
        end
        # page.fill_in 'assembly_description', :with => attribs[:description]
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.show.header')}$/
      page.should_not have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      # find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\z/  # be whitespace
      attribs.each do | at_key, at_val |
        if at_key.to_s == 'deactivated'
          Rails.logger.debug("T assemblies_integration_spec updated attribs - deactivated")
          find(:xpath, "//*[@id=\"assembly_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/ 
        elsif at_val.is_a?(TrueClass)
          Rails.logger.debug("T assemblies_integration_spec updated attribs - #{at_key.to_s} - TrueClass")
          find(:xpath, "//*[@id=\"assembly_#{at_key.to_s}\"]").text.should =~ /^true$/
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T assemblies_integration_spec updated attribs - #{at_key.to_s} - FalseClass")
          find(:xpath, "//*[@id=\"assembly_#{at_key.to_s}\"]").text.should =~ /^false$/
        else
          Rails.logger.debug("T assemblies_integration_spec updated attribs - #{at_key.to_s}")
          find(:xpath, "//*[@id=\"assembly_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s}\z/ 
        end
      end
      # find(:xpath, '//*[@id="assembly_description"]').text.should =~ /\AMy Description\z/  # be new value
      num_items.should == Assembly.count - 1
    end
    it 'should notify user when trying to create a user missing required fields' do
      # dont do this if min size == 0
      Rails.logger.debug("T assemblies_integration_spec #{FactoryGirl.attributes_for(:assembly_min_create).size}")
      if FactoryGirl.attributes_for(:assembly_min_create).size > 0
        num_items = Assembly.count
        visit new_assembly_path()
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.new.header')}$/
        # save_and_open_page      
        within(".new_assembly") do
          find(:xpath, '//input[@type="submit"]').click
        end
        # save_and_open_page
        page.driver.status_code.should be 200
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.new.header')}$/
        page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
        find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\z/  # be whitespace
        page.should have_selector(:xpath, '//span[@class="field_with_errors"]')
        num_items.should == Assembly.count
      end
    end
    it 'should be able to edit and update all of an items accessible fields' do
      all_attribs = FactoryGirl.attributes_for(:assembly_accessible)
      item1 = Assembly.create!(FactoryGirl.attributes_for(:assembly_min_create))
      item1.deactivated?.should be_false
      visit edit_assembly_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.edit.header')}$/
      within(".edit_assembly") do
        all_attribs.each do | at_key, at_val |
          Rails.logger.debug("T assemblies_integration_spec edit update - key-val:#{at_key.to_s}-#{at_val.to_s}")
          if at_val.is_a?(TrueClass)
            Rails.logger.debug("T assemblies_integration_spec edit update - TrueClass")
            page.choose("assembly_#{at_key.to_s}_true")
            page.should have_selector(:xpath, "//*[@id=\"assembly_#{at_key.to_s}_true\" and @checked]")
          elsif at_val.is_a?(FalseClass)
            Rails.logger.debug("T assemblies_integration_spec edit update - FalseClass")
            page.choose("assembly_#{at_key.to_s}_false")
            page.should have_selector(:xpath, "//*[@id=\"assembly_#{at_key.to_s}_false\" and @checked]")
          else
            # simply fill in the field
            Rails.logger.debug("T assemblies_integration_spec edit update - other class")
            page.fill_in "assembly_#{at_key.to_s}", :with => at_val
          end
        end
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.show.header')}$/
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ 
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => item1.class.name, :id => item1.id )}$/
      all_attribs.each do | at_key, at_val |
        if at_key.to_s == 'deactivated'
          Rails.logger.debug("T assemblies_integration_spec edit updated show - deactivated")
          find(:xpath, "//*[@id=\"assembly_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/ 
        elsif at_val.is_a?(TrueClass)
          Rails.logger.debug("T assemblies_integration_spec edit updated show #{at_key.to_s} - TrueClass")
          find(:xpath, "//*[@id=\"assembly_#{at_key.to_s}\"]").text.should =~ /^true$/
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T assemblies_integration_spec edit updated show #{at_key.to_s} - FalseClass")
          find(:xpath, "//*[@id=\"assembly_#{at_key.to_s}\"]").text.should =~ /^false$/
        else
          find(:xpath, "//*[@id=\"assembly_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s}\z/ 
        end
      end
      updated_item = Assembly.find(item1.id)
      all_attribs.each do | at_key, at_val |
        updated_item.send(at_key.to_s).should == at_val
      end
    end
    it 'should be able to show all accessible fields of an item' do
      all_attribs = FactoryGirl.attributes_for(:assembly_accessible)
      item1 = Assembly.create!(all_attribs)
      item1.deactivated?.should == all_attribs[:deactivated]
      # visit (assembly_path, item1, :show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      visit "/assemblies/#{item1.id}?show_deactivated=true" # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.show.header')}$/
      all_attribs.each do | at_key, at_val |
        if at_key.to_s == 'deactivated'
          Rails.logger.debug("T assemblies_integration_spec edit updated show - deactivated")
          find(:xpath, "//*[@id=\"assembly_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/ 
        elsif at_val.is_a?(TrueClass)
          Rails.logger.debug("T assemblies_integration_spec edit updated show #{at_key.to_s} - TrueClass")
          find(:xpath, "//*[@id=\"assembly_#{at_key.to_s}\"]").text.should =~ /^true$/
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T assemblies_integration_spec edit updated show #{at_key.to_s} - FalseClass")
          find(:xpath, "//*[@id=\"assembly_#{at_key.to_s}\"]").text.should =~ /^false$/
        else
          find(:xpath, "//*[@id=\"assembly_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s}\z/ 
        end
      end
    end
  end
  context 'component layouts - ' do
    before(:each) do
      @item1 = FactoryGirl.create(:assembly_min_create)
    end
    context 'should have index/list row links working' do
      before(:each) do
        visit assemblies_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.index.header')}$/
        page.should have_selector(:xpath, "//tr[@id=\"assembly_#{@item1.id}\"]/td/a", :text =>  I18n.translate('view_action.view') )
        page.should have_selector(:xpath, "//tr[@id=\"assembly_#{@item1.id}\"]/td/a", :text =>  I18n.translate('view_action.edit') )
      end
      it 'has clickable show button' do
        find(:xpath, "//tr[@id=\"assembly_#{@item1.id}\"]/td/a", :text =>  I18n.translate('view_action.view') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.show.header')}$/
      end
      it 'has clickable edit button' do
        find(:xpath, "//tr[@id=\"assembly_#{@item1.id}\"]/td/a", :text =>  I18n.translate('view_action.edit') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.edit.header')}$/
      end
    end
    context 'should have index links working' do
      before(:each) do
        visit assemblies_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.index.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/a", :text =>  I18n.translate('assemblies.new.action') )
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body']/a", :text =>  I18n.translate('assemblies.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.new.header')}$/
      end
    end
    context 'should have list links working' do
      before(:each) do
        visit list_assemblies_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.list.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/a", :text => I18n.translate('assemblies.new.action') )
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body']/a", :text => I18n.translate('assemblies.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.new.header')}$/
      end
    end
    context 'should have menu links working' do
      before(:each) do
        visit assemblies_menu_path()
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.menu.header')}$/
        page.should have_selector(:xpath, "//span[@id='index_action']/a", :text => I18n.translate('assemblies.index.action') )
        page.should have_selector(:xpath, "//span[@id='list_action']/a", :text => I18n.translate('assemblies.list.action') )
      end
      it 'has clickable index link' do
        find(:xpath, "//span[@id='index_action']/a", :text => I18n.translate('assemblies.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.index.header')}$/
      end
      it 'has clickable list link' do
        find(:xpath, "//span[@id='list_action']/a", :text => I18n.translate('assemblies.list.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.list.header')}$/
      end
    end
    context 'should have new/create links working' do
      before(:each) do
        visit new_assembly_path()
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.new.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/a", :text => I18n.translate('assemblies.index.action') )
      end
      it 'has clickable index link' do
        find(:xpath, "//div[@id='content_body']/a", :text => I18n.translate('assemblies.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.index.header')}$/
      end
    end
    context 'should have edit/update links working' do
      before(:each) do
        visit edit_assembly_path(@item1.id)
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.edit.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/a", :text =>  I18n.translate('assemblies.show.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/a", :text => I18n.translate('assemblies.index.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/a", :text => I18n.translate('assemblies.list.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/a", :text => I18n.translate('assemblies.new.action') )
      end
      it 'has clickable show button' do
        find(:xpath, "//div[@id='content_body']/a", :text =>  I18n.translate('assemblies.show.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.show.header')}$/
      end
      it 'has clickable index link' do
        find(:xpath, "//div[@id='content_body']/a", :text => I18n.translate('assemblies.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.index.header')}$/
      end
      it 'has clickable list link' do
        find(:xpath, "//div[@id='content_body']/a", :text => I18n.translate('assemblies.list.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.list.header')}$/
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body']/a", :text => I18n.translate('assemblies.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.new.header')}$/
      end
    end
    context 'should have show links working' do
      before(:each) do
        visit assembly_path(@item1.id)
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.show.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/a", :text =>  I18n.translate('assemblies.edit.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/a", :text => I18n.translate('assemblies.index.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/a", :text => I18n.translate('assemblies.list.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/a", :text => I18n.translate('assemblies.new.action') )
      end
      it 'has clickable edit button' do
        find(:xpath, "//div[@id='content_body']/a", :text =>  I18n.translate('assemblies.edit.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.edit.header')}$/
      end
      it 'has clickable index link' do
        find(:xpath, "//div[@id='content_body']/a", :text => I18n.translate('assemblies.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.index.header')}$/
      end
      it 'has clickable list link' do
        find(:xpath, "//div[@id='content_body']/a", :text => I18n.translate('assemblies.list.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.list.header')}$/
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body']/a", :text => I18n.translate('assemblies.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.new.header')}$/
      end
    end
  end
  context 'it should have deactivated actions available and working' do
    it 'should be able to list all items when show_deactivated is set' do
      item1 = Assembly.create!(FactoryGirl.attributes_for(:assembly_create))
      item_deact = Assembly.create!(FactoryGirl.attributes_for(:assembly_create).merge({:deactivated => DB_TRUE.to_s}))
      visit assemblies_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.index.header')}$/
      find(:xpath, "//tr[@id=\"assembly_#{item1.id}\"]/td[@id=\"assembly_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      # find(:xpath, "(//tr[@id=\"assembly_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"assembly_#{item1.id}\"]").should have_selector(:xpath, "//a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
      find(:xpath, "//tr[@id=\"assembly_#{item_deact.id}\"]/td[@id=\"assembly_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      # find(:xpath, "(//tr[@id=\"assembly_#{item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      find(:xpath, "//tr[@id=\"assembly_#{item1.id}\"]").should have_selector(:xpath, "//a[text()=\"#{I18n.translate('view_action.reactivate')}\"]")
      find(:xpath, "//tr[@id=\"assembly_#{item_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
    end
    it 'should be able to list only active items when show_deactivated is off' do
      item1 = Assembly.create!(FactoryGirl.attributes_for(:assembly_create))
      item1.deactivated?.should be_false
      item_deact = Assembly.create!(FactoryGirl.attributes_for(:assembly_create).merge({:deactivated => DB_TRUE.to_s}))
      visit assemblies_path(:show_deactivated => DB_FALSE.to_s) # dont show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.index.header')}$/
      page.should have_selector(:xpath, "//tr[@id=\"assembly_#{item1.id}\"]")
      page.should_not have_selector(:xpath, "//tr[@id=\"assembly_#{item_deact.id}\"]")
    end
    it 'should not see deactivate option on a deactivated item' do
      item_deact = Assembly.create!(FactoryGirl.attributes_for(:assembly_create).merge({:deactivated => DB_TRUE.to_s}))
      visit assemblies_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.index.header')}$/
      find(:xpath, "//tr[@id=\"assembly_#{item_deact.id}\"]/td[@id=\"assembly_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "//tr[@id=\"assembly_#{item_deact.id}\"]").should have_selector(:xpath, "//a[text()=\"#{I18n.translate('view_action.reactivate')}\"]")
      find(:xpath, "//tr[@id=\"assembly_#{item_deact.id}\"]").should_not have_selector(:xpath, "//a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
    end
    it 'should not see reactivate option on an active item' do
      item_active = Assembly.create!(FactoryGirl.attributes_for(:assembly_create))
      visit assemblies_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.index.header')}$/
      find(:xpath, "//tr[@id=\"assembly_#{item_active.id}\"]/td[@id=\"assembly_#{item_active.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "//tr[@id=\"assembly_#{item_active.id}\"]").should_not have_selector(:xpath, "//a[text()=\"#{I18n.translate('view_action.reactivate')}\"]")
      find(:xpath, "//tr[@id=\"assembly_#{item_active.id}\"]").should have_selector(:xpath, "//a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
    end
    it 'should not see delete on an active item' do
      item_active = Assembly.create!(FactoryGirl.attributes_for(:assembly_create))
      visit assemblies_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.index.header')}$/
      find(:xpath, "//tr[@id=\"assembly_#{item_active.id}\"]/td[@id=\"assembly_#{item_active.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "//tr[@id=\"assembly_#{item_active.id}\"]").should_not have_selector(:xpath, "//a[@data-method=\"delete\"]")
    end
    it 'should see delete on a deactivated item' do
      item_deact = Assembly.create!(FactoryGirl.attributes_for(:assembly_create).merge({:deactivated => DB_TRUE.to_s}))
      visit assemblies_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.index.header')}$/
      find(:xpath, "//tr[@id=\"assembly_#{item_deact.id}\"]/td[@id=\"assembly_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "//tr[@id=\"assembly_#{item_deact.id}\"]").should have_selector(:xpath, "//a[@data-method=\"delete\"]")
    end
    it 'should GET show the active item as not deactivated' do
      item1 = Assembly.create!(FactoryGirl.attributes_for(:assembly_create))
      item1.deactivated?.should be_false
      visit assembly_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.show.header')}$/
      find(:xpath, '//*[@id="assembly_deactivated"]').text.should_not =~ /\A\s*\z/
      find(:xpath, '//*[@id="assembly_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    end
    it 'should see the deactivated field in edit' do
      item1 = Assembly.create!(FactoryGirl.attributes_for(:assembly_create))
      item1.deactivated?.should be_false
      visit edit_assembly_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.edit.header')}$/
      page.should_not have_selector(:xpath, "//*[@id=\"assembly_deactivated_true\" and @checked]")
      page.should have_selector(:xpath, "//*[@id=\"assembly_deactivated_false\" and @checked]")
    end
    it 'controller should list items with deactivate/reactivate action/link/button depending upon status' do
      item1 = Assembly.create!(FactoryGirl.attributes_for(:assembly_create))
      item1.deactivated?.should be_false
      @item_deact = Assembly.create!(FactoryGirl.attributes_for(:assembly_create).merge({:deactivated => DB_TRUE.to_s}))
      Assembly.count.should > 1
      visit assemblies_path(:show_deactivated => DB_TRUE.to_s) # need to show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.index.header')}$/
      find(:xpath, "//tr[@id=\"assembly_#{item1.id}\"]/td[@id=\"assembly_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"assembly_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"assembly_#{@item_deact.id}\"]/td[@id=\"assembly_#{@item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "(//tr[@id=\"assembly_#{@item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      find(:xpath, "//tr[@id=\"assembly_#{@item_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
    end
    it 'Update action should allow a change from deactivated to active' do
      item1 = Assembly.create!(FactoryGirl.attributes_for(:assembly_create))
      item1.deactivated?.should be_false
      item1.deactivate
      @updated_item = Assembly.find(item1.id)
      @updated_item.deactivated?.should be_true
      @num_items = Assembly.count
      visit ("/assemblies/#{item1.id}/edit?show_deactivated=true")
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.edit.header')}$/
      page.should have_selector(:xpath, "//*[@id=\"assembly_deactivated_true\" and @checked]")
      page.should_not have_selector(:xpath, "//*[@id=\"assembly_deactivated_false\" and @checked]")
      within(".edit_assembly") do
        page.choose("assembly_deactivated_false")
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('assemblies.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => item1.class.name, :id => @updated_item.id )}/
      Assembly.count.should == (@num_items)
      find(:xpath, "//*[@id=\"assembly_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      @updated_item = Assembly.find(item1.id)
      @updated_item.deactivated?.should be_false
    end
    it 'Update action should allow a change from active to deactivated' do
      item1 = Assembly.create!(FactoryGirl.attributes_for(:assembly_create))
      item1.deactivated?.should be_false
      @num_items = Assembly.count
      visit edit_assembly_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.edit.header')}$/
      page.should_not have_selector(:xpath, "//*[@id=\"assembly_deactivated_true\" and @checked]")
      page.should have_selector(:xpath, "//*[@id=\"assembly_deactivated_false\" and @checked]")
      within(".edit_assembly") do
        page.choose("assembly_deactivated_true")
        # select I18n.translate('view_field_value.deactivated'), :from => 'assembly_deactivated'
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => item1.class.name, :id => item1.id )}$/
      Assembly.count.should == (@num_items)
      find(:xpath, "//*[@id=\"assembly_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      @updated_item = Assembly.find(item1.id)
      @updated_item.deactivated?.should be_true
    end
    it 'should allow a item to be deactivated from the index page' do
      item1 = Assembly.create!(FactoryGirl.attributes_for(:assembly_create))
      item1.deactivated?.should be_false
      @item_deact = Assembly.create!(FactoryGirl.attributes_for(:assembly_create).merge({:deactivated => DB_TRUE}))
      @num_items = Assembly.count
      @num_items.should > 1
      visit assemblies_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.index.header')}$/
      find(:xpath, "//tr[@id=\"assembly_#{item1.id}\"]/td[@id=\"assembly_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"assembly_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"assembly_#{item1.id}\"]//a", :text => I18n.translate('view_action.deactivate') ).click
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'deactivate', :obj => item1.class.name, :id => item1.id )}$/
      Assembly.count.should == (@num_items)
      @updated_item = Assembly.find(item1.id)
      @updated_item.deactivated?.should be_true
    end
    it 'should allow a item to be reactivated from the index page' do
      item1 = Assembly.create!(FactoryGirl.attributes_for(:assembly_create))
      item1.deactivated?.should be_false
      @item_deact = Assembly.create!(FactoryGirl.attributes_for(:assembly_create).merge({:deactivated => DB_TRUE}))
      @num_items = Assembly.count
      @num_items.should > 1
      visit assemblies_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.index.header')}$/
      find(:xpath, "//tr[@id=\"assembly_#{@item_deact.id}\"]/td[@id=\"assembly_#{@item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.translate('view_field_value.deactivated')}\z/
      find(:xpath, "(//tr[@id=\"assembly_#{@item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      # click on reactivate button of deactivated item
      find(:xpath, "//tr[@id=\"assembly_#{@item_deact.id}\"]//a", :text => I18n.translate('view_action.reactivate') ).click
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'reactivate', :obj => item1.class.name, :id => @item_deact.id )}$/
      Assembly.count.should == (@num_items)
      find(:xpath, "//*[@id=\"assembly_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      @updated_item = Assembly.find(item1.id)
      @updated_item.deactivated?.should be_false
    end    
    it 'should not list deactivated items by assembly' do
      item1 = Assembly.create!(FactoryGirl.attributes_for(:assembly_create))
      item1.deactivated?.should be_false
      @item_deact = Assembly.create!(FactoryGirl.attributes_for(:assembly_create).merge({:deactivated => DB_TRUE}))
      Assembly.count.should > 1
      # get assemblies_path
      # response.status.should be(200)
      visit assemblies_path()
      page.driver.status_code.should be 200
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('assemblies.index.header')}$/
      # find(:xpath, "//tr[@id=\"assembly_#{item1.id}\"]/td[@class=\"assembly_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"assembly_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      page.should_not have_selector(:xpath, "//tr[@id=\"assembly_#{@item_deact.id}\"]/td[@class=\"assembly_deactivated\"]", :text => I18n.is_deactivated_or_not(true) )
    end   
  end
end
