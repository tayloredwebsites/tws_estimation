# spec/integration/components_integration_spec.rb

require 'spec_helper'
include UserIntegrationHelper
include ApplicationHelper

describe 'Components Integration Tests' do

  before(:each) do
    @user1 = User.create!(FactoryGirl.attributes_for(:user_min_create_attr))
    @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
    helper_signin(:admin_user_full_create_attr, @me.full_name)
    helper_load_defaults
    helper_load_component_types
    visit home_index_path
    Rails.logger.debug("T components_integration_spec Admin item logged in before - done")
  end
  context 'it should have crud actions available and working' do
    it "should create a new item with parent association specified" do
      num_items = Component.count
      num_items.should == 0
      visit new_component_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page      
      attribs = FactoryGirl.attributes_for(:component_create, component_type: @component_type, default: @default)
      Rails.logger.debug("T components_integration_spec - attribs = #{attribs.inspect.to_s}")
      within(".new_component") do
        page.select @component_type.description, :from => 'component_component_type_id'
        page.fill_in 'component_description', :with => attribs[:description]
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.show.header')}$/
      page.should_not have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      # find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\Z/  # be whitespace
      find(:xpath, '//*[@id="component_description"]').text.should =~ /^#{attribs[:description]}/  # be new value
      num_items.should == Component.count - 1
    end
    it "should not create a new item without parent association specified" do
      num_items = Component.count
      num_items.should == 0
      visit new_component_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page      
      attribs = FactoryGirl.attributes_for(:component_create, component_type: @component_type, default: @default)
      Rails.logger.debug("T components_integration_spec - attribs = #{attribs.inspect.to_s}")
      within(".new_component") do
        # page.select @component_type.description, :from => 'component_component_type_id'
        page.fill_in 'component_description', :with => attribs[:description]
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.new.header')}$/
      page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      # find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should_not =~ /\A\s*\Z$/  # be whitespace
      find(:xpath, '//input[@id="component_description"]').value.should =~ /#{attribs[:description]}/  # be new value
      num_items.should == Component.count
    end
    it 'should notify user when trying to create a user missing required fields' do
      item1 = FactoryGirl.create(:component_min_create, component_type: @component_type, default: @default)
      # dont do this if min size == 0
      Rails.logger.debug("T components_integration_spec #{FactoryGirl.attributes_for(:component_min_create).size}")
      if FactoryGirl.attributes_for(:component_min_create).size > 0
        num_items = Component.count
        visit new_component_path()
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.new.header')}$/
        # save_and_open_page      
        within(".new_component") do
          find(:xpath, '//input[@type="submit"]').click
        end
        # save_and_open_page
        page.driver.status_code.should be 200
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.new.header')}$/
        page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
        # find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\z/  # be whitespace
        page.should have_selector(:xpath, '//span[@class="field_with_errors"]')
        num_items.should == Component.count
      end
    end
    it 'should be able to edit and update all of an items accessible fields' do
      all_attribs = FactoryGirl.attributes_for(:component_accessible)
      item1 = FactoryGirl.create(:component_accessible, component_type: @component_type, default: @default)
      # item1.deactivated?.should be_true
      # visit edit_component_path (item1.id)
      visit ("/components/#{item1.id}/edit?show_deactivated=true")
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.edit.header')}$/
      within(".edit_component") do
        all_attribs.each do | at_key, at_val |
          Rails.logger.debug("T components_integration_spec edit update - key-val:#{at_key.to_s}-#{at_val.to_s}")
          if at_val.is_a?(TrueClass)
            Rails.logger.debug("T components_integration_spec edit update - TrueClass")
            page.choose("component_#{at_key.to_s}_true")
            page.should have_selector(:xpath, "//*[@id=\"component_#{at_key.to_s}_true\" and @checked]")
          elsif at_val.is_a?(FalseClass)
            Rails.logger.debug("T components_integration_spec edit update - FalseClass")
            page.choose("component_#{at_key.to_s}_false")
            page.should have_selector(:xpath, "//*[@id=\"component_#{at_key.to_s}_false\" and @checked]")
          elsif at_key.to_s == 'grid_operand' # ['grid_operand', 'grid_scope'].include?(at_key.to_s)
            Rails.logger.debug("T components_integration_spec edit update - select box - grid_operand")
            page.select(at_val.to_s + ' - ' + VALID_GRID_OPERANDS[at_val], :from => "component_#{at_key.to_s}")
            find(:xpath, "//select[@id=\"component_#{at_key.to_s}\"]").value.should == at_val.to_s
          elsif at_key.to_s == 'grid_scope' # ['grid_operand', 'grid_scope'].include?(at_key.to_s)
            Rails.logger.debug("T components_integration_spec edit update - select box - grid_scope")
            page.select(at_val.to_s + ' - ' + VALID_GRID_SCOPES[at_val], :from => "component_#{at_key.to_s}")
            find(:xpath, "//select[@id=\"component_#{at_key.to_s}\"]").value.should == at_val.to_s
          else
            # simply fill in the field
            Rails.logger.debug("T components_integration_spec edit update - other class")
            page.fill_in "component_#{at_key.to_s}", :with => at_val
          end
        end
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.show.header')}$/
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ 
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => item1.class.name, :id => item1.id )}$/
      all_attribs.each do | at_key, at_val |
        if at_key.to_s == 'deactivated'
          Rails.logger.debug("T components_integration_spec edit updated show - deactivated")
          find(:xpath, "//*[@id=\"component_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/ 
        elsif at_val.is_a?(TrueClass)
          Rails.logger.debug("T components_integration_spec edit updated show #{at_key.to_s} - TrueClass")
          find(:xpath, "//*[@id=\"component_#{at_key.to_s}\"]").text.should =~ /^true$/
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T components_integration_spec edit updated show #{at_key.to_s} - FalseClass")
          find(:xpath, "//*[@id=\"component_#{at_key.to_s}\"]").text.should =~ /^false$/
        elsif  'grid_operand' == at_key.to_s
          Rails.logger.debug("T components_integration_spec show grid selected values")
          key_lookup = VALID_GRID_OPERANDS[at_val.to_s]
          Rails.logger.debug("T components_integration_spec show #{key_lookup}")
          find(:xpath, "//*[@id=\"component_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s} - #{key_lookup}\z/ 
        elsif  'grid_scope' == at_key.to_s
          Rails.logger.debug("T components_integration_spec show grid selected values")
          key_lookup = VALID_GRID_SCOPES[at_val.to_s]
          Rails.logger.debug("T components_integration_spec show #{key_lookup}")
          find(:xpath, "//*[@id=\"component_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s} - #{key_lookup}\z/ 
        else
          find(:xpath, "//*[@id=\"component_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s}\z/ 
        end
      end
      updated_item = Component.find(item1.id)
      all_attribs.each do | at_key, at_val |
        updated_item.send(at_key.to_s).should == at_val
      end
    end
    it 'should be able to show all accessible fields of an item' do
      all_attribs = FactoryGirl.attributes_for(:component_accessible)
      item1 = FactoryGirl.create(:component_accessible, component_type: @component_type, default: @default)
      item1.deactivated?.should be_true
      # visit (component_path, item1, :show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      visit "/components/#{item1.id}?show_deactivated=true" # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.show.header')}$/
      all_attribs.each do | at_key, at_val |
        if at_key.to_s == 'deactivated'
          Rails.logger.debug("T components_integration_spec edit updated show - deactivated")
          find(:xpath, "//*[@id=\"component_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/ 
        elsif at_val.is_a?(TrueClass)
          Rails.logger.debug("T components_integration_spec edit updated show #{at_key.to_s} - TrueClass")
          find(:xpath, "//*[@id=\"component_#{at_key.to_s}\"]").text.should =~ /^true$/
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T components_integration_spec edit updated show #{at_key.to_s} - FalseClass")
          find(:xpath, "//*[@id=\"component_#{at_key.to_s}\"]").text.should =~ /^false$/
        elsif  'grid_operand' == at_key.to_s
          Rails.logger.debug("T components_integration_spec show grid selected values")
          key_lookup = VALID_GRID_OPERANDS[at_val.to_s]
          Rails.logger.debug("T components_integration_spec show #{key_lookup}")
          find(:xpath, "//*[@id=\"component_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s} - #{key_lookup}\z/ 
        elsif  'grid_scope' == at_key.to_s
          Rails.logger.debug("T components_integration_spec show grid selected values #{at_key.to_s}, #{at_val.to_s}")
          key_lookup = VALID_GRID_SCOPES[at_val.to_s]
          Rails.logger.debug("T components_integration_spec show #{key_lookup}")
          find(:xpath, "//*[@id=\"component_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s} - #{key_lookup}\z/ 
        else
          find(:xpath, "//*[@id=\"component_#{at_key.to_s}\"]").text.should =~ /\A#{at_val.to_s}\z/ 
        end
      end
    end
  end
  
  context 'component layouts - ' do
    before(:each) do
      @item1 = FactoryGirl.create(:component_min_create, component_type: @component_type, default: @default)
    end
    context 'Header Show/Hide Deactivated links - ' do
      it 'should send index page with correct show/hide link in table header' do
        visit components_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
        page.should have_selector(:xpath, "//th/a", :text =>  I18n.translate('view_action.hide_deactivated') )
        # hide deactivated records
        find(:xpath, "//th/a", :text =>  I18n.translate('view_action.hide_deactivated') ).click
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
        page.should have_selector(:xpath, "//th/a", :text =>  I18n.translate('view_action.show_deactivated') )
        # show deactivated records
        find(:xpath, "//th/a", :text =>  I18n.translate('view_action.show_deactivated') ).click
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
        page.should have_selector(:xpath, "//th/a", :text =>  I18n.translate('view_action.hide_deactivated') )
      end
      it 'should send list page with correct show/hide link in table header' do
        visit list_components_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.list.header')}$/
        page.should have_selector(:xpath, "//th/a", :text =>  I18n.translate('view_action.hide_deactivated') )
        # hide deactivated records
        find(:xpath, "//th/a", :text =>  I18n.translate('view_action.hide_deactivated') ).click
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.list.header')}$/
        page.should have_selector(:xpath, "//th/a", :text =>  I18n.translate('view_action.show_deactivated') )
        # show deactivated records
        find(:xpath, "//th/a", :text =>  I18n.translate('view_action.show_deactivated') ).click
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.list.header')}$/
        page.should have_selector(:xpath, "//th/a", :text =>  I18n.translate('view_action.hide_deactivated') )
      end
    end
    context 'should have index/list row links working' do
      before(:each) do
        visit components_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
        page.should have_selector(:xpath, "//tr[@id=\"component_#{@item1.id}\"]/td/a", :text =>  I18n.translate('view_action.view') )
        page.should have_selector(:xpath, "//tr[@id=\"component_#{@item1.id}\"]/td/a", :text =>  I18n.translate('view_action.edit') )
      end
      it 'has clickable show button' do
        find(:xpath, "//tr[@id=\"component_#{@item1.id}\"]/td/a", :text =>  I18n.translate('view_action.view') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.show.header')}$/
      end
      it 'has clickable edit button' do
        find(:xpath, "//tr[@id=\"component_#{@item1.id}\"]/td/a", :text =>  I18n.translate('view_action.edit') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.edit.header')}$/
      end
    end
    context 'should have index parent links working' do
      before(:each) do
        visit components_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/h3/a", :text => "#{@item1.component_type.nil_to_s}" )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  "New #{@item1.component_type.nil_to_s} Component" )
      end
      it 'has clickable parent view link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/h3/a", :text => "#{@item1.component_type.nil_to_s}" ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('component_types.show.header')}$/
      end
      it 'has clickable parent new child button' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  "New #{@item1.component_type.nil_to_s} Component" ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.new.header')}$/
      end
    end
    it 'should have index links working with clickable create new link' do
      visit components_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
      page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('components.new.action') )
      find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a[@href=\"/components/new\"]", :text =>  I18n.translate('components.new.action') ).click
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.new.header')}$/
    end
    it 'should have list links working with clickable create new link' do
      visit list_components_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.list.header')}$/
      page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('components.new.action') )
      find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a[@href=\"/components/new\"]", :text => I18n.translate('components.new.action') ).click
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.new.header')}$/
    end
    context 'should have menu links working' do
      before(:each) do
        visit components_menu_path()
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.menu.header')}$/
        page.should have_selector(:xpath, "//span[@id='index_action']/a", :text => I18n.translate('components.index.action') )
        page.should have_selector(:xpath, "//span[@id='list_action']/a", :text => I18n.translate('components.list.action') )
      end
      it 'has clickable index link' do
        find(:xpath, "//span[@id='index_action']/a", :text => I18n.translate('components.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
      end
      it 'has clickable list link' do
        find(:xpath, "//span[@id='list_action']/a", :text => I18n.translate('components.list.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.list.header')}$/
      end
    end
    context 'should have new/create links working' do
      before(:each) do
        visit new_component_path()
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.new.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('components.index.action') )
      end
      it 'has clickable index link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('components.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
      end
    end
    context 'should have edit/update links working' do
      before(:each) do
        visit edit_component_path(@item1.id)
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.edit.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('components.show.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('components.index.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('components.list.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('components.new.action') )
      end
      it 'has clickable show button' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('components.show.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.show.header')}$/
      end
      it 'has clickable index link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('components.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
      end
      it 'has clickable list link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('components.list.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.list.header')}$/
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('components.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.new.header')}$/
      end
    end
    context 'should have show links working' do
      before(:each) do
        visit component_path(@item1.id)
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.show.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('components.edit.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('components.index.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('components.list.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('components.new.action') )
      end
      it 'has clickable edit button' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('components.edit.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.edit.header')}$/
      end
      it 'has clickable index link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('components.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
      end
      it 'has clickable list link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('components.list.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.list.header')}$/
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('components.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.new.header')}$/
      end
    end
  end
  context 'it should have deactivated actions available and working' do
    it 'should be able to list all items when show_deactivated is set' do
      item1 = FactoryGirl.create(:component_min_create, component_type: @component_type, default: @default)
      item1.deactivated?.should be_false
      item_deact = FactoryGirl.create(:component_accessible_create, component_type: @component_type, default: @default)
      item_deact.deactivated?.should be_true
      visit components_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
      find(:xpath, "//tr[@id=\"component_#{item1.id}\"]/td[@id=\"component_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      # find(:xpath, "(//tr[@id=\"component_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"component_#{item1.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
      find(:xpath, "//tr[@id=\"component_#{item_deact.id}\"]/td[@id=\"component_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      # find(:xpath, "(//tr[@id=\"component_#{item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      find(:xpath, "//tr[@id=\"component_#{item_deact.id}\"]").should have_selector(:xpath, "td/a", :text => "#{I18n.translate('view_action.reactivate')}")
      find(:xpath, "//tr[@id=\"component_#{item_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
    end
    it 'should be able to list only active items when show_deactivated is off' do
      item1 = FactoryGirl.create(:component_min_create, component_type: @component_type, default: @default)
      item1.deactivated?.should be_false
      item_deact = FactoryGirl.create(:component_accessible_create, component_type: @component_type, default: @default)
      visit components_path(:show_deactivated => DB_FALSE.to_s) # dont show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
      page.should have_selector(:xpath, "//tr[@id=\"component_#{item1.id}\"]")
      page.should_not have_selector(:xpath, "//tr[@id=\"component_#{item_deact.id}\"]")
    end
    it 'should not see deactivate option on a deactivated item' do
      item_deact = FactoryGirl.create(:component_accessible_create, component_type: @component_type, default: @default)
      visit components_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
      find(:xpath, "//tr[@id=\"component_#{item_deact.id}\"]/td[@id=\"component_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "//tr[@id=\"component_#{item_deact.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.reactivate')}\"]")
      find(:xpath, "//tr[@id=\"component_#{item_deact.id}\"]").should_not have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
    end
    it 'should not see reactivate option on an active item' do
      item_active = FactoryGirl.create(:component_min_create, component_type: @component_type, default: @default)
      visit components_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
      find(:xpath, "//tr[@id=\"component_#{item_active.id}\"]/td[@id=\"component_#{item_active.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "//tr[@id=\"component_#{item_active.id}\"]").should_not have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.reactivate')}\"]")
      find(:xpath, "//tr[@id=\"component_#{item_active.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
    end
    it 'should not see delete on an active item' do
      item_active = FactoryGirl.create(:component_min_create, component_type: @component_type, default: @default)
      visit components_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
      find(:xpath, "//tr[@id=\"component_#{item_active.id}\"]/td[@id=\"component_#{item_active.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "//tr[@id=\"component_#{item_active.id}\"]").should_not have_selector(:xpath, "td/a[@data-method=\"delete\"]")
    end
    it 'should see delete on a deactivated item' do
      item_deact = FactoryGirl.create(:component_accessible_create, component_type: @component_type, default: @default)
      visit components_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
      find(:xpath, "//tr[@id=\"component_#{item_deact.id}\"]/td[@id=\"component_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "//tr[@id=\"component_#{item_deact.id}\"]").should have_selector(:xpath, "td/a[@data-method=\"delete\"]")
    end
    it 'should GET show the active item as not deactivated' do
      item1 = FactoryGirl.create(:component_min_create, component_type: @component_type, default: @default)
      item1.deactivated?.should be_false
      visit component_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.show.header')}$/
      find(:xpath, '//*[@id="component_deactivated"]').text.should_not =~ /\A\s*\z/
      find(:xpath, '//*[@id="component_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    end
    it 'should see the deactivated field in edit' do
      item1 = FactoryGirl.create(:component_min_create, component_type: @component_type, default: @default)
      item1.deactivated?.should be_false
      visit edit_component_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.edit.header')}$/
      page.should_not have_selector(:xpath, "//*[@id=\"component_deactivated_true\" and @checked]")
      page.should have_selector(:xpath, "//*[@id=\"component_deactivated_false\" and @checked]")
    end
    it 'controller should list items with deactivate/reactivate action/link/button depending upon status' do
      item1 = FactoryGirl.create(:component_min_create, component_type: @component_type, default: @default)
      item1.deactivated?.should be_false
      @item_deact = FactoryGirl.create(:component_accessible_create, component_type: @component_type, default: @default)
      Component.count.should > 1
      visit components_path(:show_deactivated => DB_TRUE.to_s) # need to show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
      find(:xpath, "//tr[@id=\"component_#{item1.id}\"]/td[@id=\"component_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"component_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"component_#{@item_deact.id}\"]/td[@id=\"component_#{@item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "(//tr[@id=\"component_#{@item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      find(:xpath, "//tr[@id=\"component_#{@item_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
    end
    it 'Update action should allow a change from deactivated to active' do
      item1 = FactoryGirl.create(:component_min_create, component_type: @component_type, default: @default)
      item1.deactivated?.should be_false
      item1.deactivate
      @updated_item = Component.find(item1.id)
      @updated_item.deactivated?.should be_true
      @num_items = Component.count
      visit ("/components/#{item1.id}/edit?show_deactivated=true")
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.edit.header')}$/
      page.should have_selector(:xpath, "//*[@id=\"component_deactivated_true\" and @checked]")
      page.should_not have_selector(:xpath, "//*[@id=\"component_deactivated_false\" and @checked]")
      within(".edit_component") do
        page.choose("component_deactivated_false")
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('components.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => item1.class.name, :id => @updated_item.id )}/
      Component.count.should == (@num_items)
      find(:xpath, "//*[@id=\"component_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      @updated_item = Component.find(item1.id)
      @updated_item.deactivated?.should be_false
    end
    it 'Update action should allow a change from active to deactivated' do
      item1 = FactoryGirl.create(:component_min_create, component_type: @component_type, default: @default)
      item1.deactivated?.should be_false
      @num_items = Component.count
      # visit edit_component_path (item1.id)
      visit ("/components/#{item1.id}/edit?show_deactivated=true")
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.edit.header')}$/
      page.should_not have_selector(:xpath, "//*[@id=\"component_deactivated_true\" and @checked]")
      page.should have_selector(:xpath, "//*[@id=\"component_deactivated_false\" and @checked]")
      within(".edit_component") do
        page.choose("component_deactivated_true")
        # select I18n.translate('view_field_value.deactivated'), :from => 'component_deactivated'
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => item1.class.name, :id => item1.id )}$/
      Component.count.should == (@num_items)
      find(:xpath, "//*[@id=\"component_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      @updated_item = Component.find(item1.id)
      @updated_item.deactivated?.should be_true
    end
    it 'should allow a item to be deactivated from the index page' do
      item1 = FactoryGirl.create(:component_min_create, component_type: @component_type, default: @default)
      item1.deactivated?.should be_false
      @item_deact = FactoryGirl.create(:component_accessible_create, component_type: @component_type, default: @default)
      @num_items = Component.count
      @num_items.should > 1
      visit components_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
      find(:xpath, "//tr[@id=\"component_#{item1.id}\"]/td[@id=\"component_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"component_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"component_#{item1.id}\"]//a", :text => I18n.translate('view_action.deactivate') ).click
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'deactivate', :obj => item1.class.name, :id => item1.id )}$/
      Component.count.should == (@num_items)
      @updated_item = Component.find(item1.id)
      @updated_item.deactivated?.should be_true
    end
    it 'should allow a item to be reactivated from the index page' do
      item1 = FactoryGirl.create(:component_min_create, component_type: @component_type, default: @default)
      item1.deactivated?.should be_false
      @item_deact = FactoryGirl.create(:component_accessible_create, component_type: @component_type, default: @default)
      @num_items = Component.count
      @num_items.should > 1
      visit components_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
      find(:xpath, "//tr[@id=\"component_#{@item_deact.id}\"]/td[@id=\"component_#{@item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.translate('view_field_value.deactivated')}\z/
      find(:xpath, "(//tr[@id=\"component_#{@item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      # click on reactivate button of deactivated item
      find(:xpath, "//tr[@id=\"component_#{@item_deact.id}\"]//a", :text => I18n.translate('view_action.reactivate') ).click
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'reactivate', :obj => item1.class.name, :id => @item_deact.id )}$/
      Component.count.should == (@num_items)
      find(:xpath, "//*[@id=\"component_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      @updated_item = Component.find(item1.id)
      @updated_item.deactivated?.should be_false
    end    
    it 'should not list deactivated items by component_type' do
      item1 = FactoryGirl.create(:component_min_create, component_type: @component_type, default: @default)
      item1.deactivated?.should be_false
      @item_deact = FactoryGirl.create(:component_accessible_create, component_type: @component_type, default: @default)
      Component.count.should > 1
      # get components_path
      # response.status.should be(200)
      visit components_path()
      page.driver.status_code.should be 200
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('components.index.header')}$/
      # find(:xpath, "//tr[@id=\"component_#{item1.id}\"]/td[@class=\"component_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"component_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      page.should_not have_selector(:xpath, "//tr[@id=\"component_#{@item_deact.id}\"]/td[@class=\"component_deactivated\"]", :text => I18n.is_deactivated_or_not(true) )
    end   
  end
end
