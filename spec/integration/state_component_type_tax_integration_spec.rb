# spec/integration/state_component_type_tax_integration_spec.rb

# it 'should have a StateComponentTypeTax table to store the default tax rate by State and Component Type'

require 'spec_helper'
include SpecHelper
include UserIntegrationHelper
include ApplicationHelper

describe 'StateComponentTypeTaxes Integration Tests' do

  before(:each) do
    @user1 = User.create!(FactoryGirl.attributes_for(:user_create))
    @me = User.create!(FactoryGirl.attributes_for(:admin_user_full_create_attr))
    helper_signin(:admin_user_full_create_attr, @me.full_name)
    Rails.logger.debug("T state_component_type_taxes_integration_spec Admin item logged in before - done")
    @state = State.create!(FactoryGirl.attributes_for(:state))
    @job_type_reg = JobType.create!(FactoryGirl.attributes_for(:job_type))
    Rails.logger.debug("T @job_type_reg : #{@job_type_reg.inspect.to_s}")
    @job_type_non_taxable = JobType.create!(FactoryGirl.attributes_for(:job_type))
    @component_type = ComponentType.create!(FactoryGirl.attributes_for(:component_type))
    tax_type_attribs = UserIntegrationHelper.build_attributes(:state_component_type_tax, state: @state, job_type: @job_type_reg, component_type: @component_type)
    Rails.logger.debug("T tax_type_attribs : #{tax_type_attribs.inspect.to_s}")
    @tax_type_reg = StateComponentTypeTax.create!(UserIntegrationHelper.build_attributes(:state_component_type_tax, state: @state, job_type: @job_type_reg, component_type: @component_type))
    @tax_type_non_taxable = StateComponentTypeTax.create!(UserIntegrationHelper.build_attributes(:state_component_type_non_taxable, state: @state, job_type: @job_type_non_taxable, component_type: @component_type))
    Rails.logger.debug("T state_component_type_taxes_integration_spec initial creations done")
    visit home_index_path
  end
  context 'it should have crud actions available and working' do
    it "should create a new item with parent association specified" do
      num_items = StateComponentTypeTax.count
      visit new_state_component_type_tax_path()
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      attribs = UserIntegrationHelper.build_attributes(:state_component_type_tax, :state => @state, :job_type => @job_type_reg, :component_type => @component_type)
      Rails.logger.debug("T state_component_type_taxes_integration_spec - attribs = #{attribs.inspect.to_s}")
      Rails.logger.debug("T state_component_type_taxes_integration_spec - attribs['tax_percent'] = #{attribs['tax_percent'].bd_to_s(4)}")
      within(".new_state_component_type_tax") do
        page.select @state.nil_to_s, :from => 'state_component_type_tax_state_id'
        page.select @job_type_reg.nil_to_s, :from => 'state_component_type_tax_job_type_id'
        page.select @component_type.nil_to_s, :from => 'state_component_type_tax_component_type_id'
        page.fill_in 'state_component_type_tax_tax_percent', :with => attribs['tax_percent']
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.show.header')}$/
      page.should_not have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      # find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~ /\A\s*\Z/  # be whitespace
      find(:xpath, '//*[@id="state_component_type_tax_state"]').text.should =~ /^#{@state.nil_to_s}/  # be new value
      find(:xpath, '//*[@id="state_component_type_tax_job_type"]').text.should =~ /^#{@job_type_reg.nil_to_s}/  # be new value
      find(:xpath, '//*[@id="state_component_type_tax_component_type"]').text.should =~ /^#{@component_type.nil_to_s}/  # be new value
      find(:xpath, '//*[@id="state_component_type_tax_tax_percent"]').text.should =~ /^#{attribs['tax_percent']}/  # be new value
      StateComponentTypeTax.count.should == num_items+ 1
    end
    it "should not create a new item without state association specified" do
      num_items = StateComponentTypeTax.count
      visit new_state_component_type_tax_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page
      attribs = UserIntegrationHelper.build_attributes(:state_component_type_tax, :state => @state, :job_type => @job_type_reg, :component_type => @component_type)
      Rails.logger.debug("T state_component_type_taxes_integration_spec - attribs = #{attribs.inspect.to_s}")
      within(".new_state_component_type_tax") do
        # page.select @state.nil_to_s, :from => 'state_component_type_tax_state_id'
        page.select @job_type_reg.nil_to_s, :from => 'state_component_type_tax_job_type_id'
        page.select @component_type.nil_to_s, :from => 'state_component_type_tax_component_type_id'
        page.fill_in 'state_component_type_tax_tax_percent', :with => attribs['tax_percent']
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.new.header')}$/
      page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      num_items.should == StateComponentTypeTax.count
    end
    it "should not create a new item without Component Type association specified" do
      num_items = StateComponentTypeTax.count
      visit new_state_component_type_tax_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page
      attribs = UserIntegrationHelper.build_attributes(:state_component_type_tax, :state => @state, :job_type => @job_type_reg, :component_type => @component_type)
      Rails.logger.debug("T state_component_type_taxes_integration_spec - attribs = #{attribs.inspect.to_s}")
      within(".new_state_component_type_tax") do
        page.select @state.nil_to_s, :from => 'state_component_type_tax_state_id'
        page.select @job_type_reg.nil_to_s, :from => 'state_component_type_tax_job_type_id'
        # page.select @component_type.nil_to_s, :from => 'state_component_type_tax_component_type_id'
        page.fill_in 'state_component_type_tax_tax_percent', :with => attribs['tax_percent']
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.new.header')}$/
      page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      num_items.should == StateComponentTypeTax.count
    end
    it "should not create a new item without Job Type association specified" do
      num_items = StateComponentTypeTax.count
      visit new_state_component_type_tax_path()
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.new.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      # save_and_open_page
      attribs = UserIntegrationHelper.build_attributes(:state_component_type_tax, :state => @state, :job_type => @job_type_reg, :component_type => @component_type)
      Rails.logger.debug("T state_component_type_taxes_integration_spec - attribs = #{attribs.inspect.to_s}")
      within(".new_state_component_type_tax") do
        page.select @state.nil_to_s, :from => 'state_component_type_tax_state_id'
        # page.select @job_type_reg.nil_to_s, :from => 'state_component_type_tax_job_type_id'
        page.select @component_type.nil_to_s, :from => 'state_component_type_tax_component_type_id'
        page.fill_in 'state_component_type_tax_tax_percent', :with => attribs['tax_percent']
        # save_and_open_page
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.new.header')}$/
      page.should have_selector(:xpath, '//div[@id="error_explanation"]', :text => I18n.translate('errors.fix_following_errors'))
      num_items.should == StateComponentTypeTax.count
    end
    it 'should be able to edit and update all of an items accessible fields' do
      all_attribs = UserIntegrationHelper.build_attributes(:state_component_type_tax, :state => @state, :job_type => @job_type_reg, :component_type => @component_type)
      item1 = StateComponentTypeTax.create(all_attribs)
      item1.deactivated?.should be_false
      visit edit_state_component_type_tax_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.edit.header')}$/
      within(".edit_state_component_type_tax") do
        all_attribs.each do | at_key, at_val |
          Rails.logger.debug("T state_component_type_taxes_integration_spec edit update - key-val:#{at_key.to_s}-#{at_val.to_s}")
          if at_val.is_a?(TrueClass)
            Rails.logger.debug("T state_component_type_taxes_integration_spec edit update - TrueClass")
            page.choose("state_component_type_tax_#{at_key.to_s}_true")
            page.should have_selector(:xpath, "//*[@id=\"state_component_type_tax_#{at_key.to_s}_true\" and @checked]")
          elsif at_val.is_a?(FalseClass)
            Rails.logger.debug("T state_component_type_taxes_integration_spec edit update - FalseClass")
            page.choose("state_component_type_tax_#{at_key.to_s}_false")
            page.should have_selector(:xpath, "//*[@id=\"state_component_type_tax_#{at_key.to_s}_false\" and @checked]")
          elsif at_val.is_a?(ActiveRecord::Base)
            Rails.logger.debug("T state_component_type_taxes_integration_spec edit update - Active Record Model - #{at_val.class.name}")
            page.select(at_val.username.to_s, :from => "state_component_type_tax_#{at_key.to_s}")
            # page.should have_selector(:xpath, "//*[@id=\"state_component_type_tax_#{at_key.to_s}\"]", :value => at_val.id.to_s)
          elsif at_key =~ /_id$/
            Rails.logger.debug("T state_component_type_taxes_integration_spec edit updated show #{at_key.to_s} - #{at_val.to_s} - Customize ID fields select option")
           if at_key == 'user_id'
             Rails.logger.debug("T state_component_type_taxes_integration_spec edit updated show #{at_key.to_s} - #{at_val.to_s} - Check the user_id field")
              page.select item1.username.to_s, :from => 'state_component_type_tax_user_id'
            end
          else
            # simply fill in the field
            Rails.logger.debug("T state_component_type_taxes_integration_spec edit update - other class")
            page.fill_in "state_component_type_tax_#{at_key.to_s}", :with => at_val
          end
        end
        # save_and_open_page
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.show.header')}$/
      find(:xpath, '//div[@id="header_status"]/p[@class="notice"]').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => item1.class.name, :id => item1.id )}$/
      all_attribs.each do | at_key, at_val |
        Rails.logger.debug("T state_component_type_taxes_integration_spec edit updated show - key-val:#{at_key.to_s}-#{at_val.to_s}")
        if at_key.to_s == 'deactivated'
          Rails.logger.debug("T state_component_type_taxes_integration_spec edit updated show - deactivated")
          find(:xpath, "//*[@id=\"state_component_type_tax_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/
        elsif at_val.is_a?(TrueClass)
          Rails.logger.debug("T state_component_type_taxes_integration_spec edit updated show #{at_key.to_s} - TrueClass")
          find(:xpath, "//*[@id=\"state_component_type_tax_#{at_key.to_s}\"]").text.should =~ /^true$/
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T state_component_type_taxes_integration_spec edit updated show #{at_key.to_s} - FalseClass")
          find(:xpath, "//*[@id=\"state_component_type_tax_#{at_key.to_s}\"]").text.should =~ /^false$/
        elsif at_val.is_a?(ActiveRecord::Base)
          Rails.logger.debug("T state_component_type_taxes_integration_spec edit updated show - Active Record Model - #{at_val.class.name}")
          page.should have_selector(:xpath, "//*[@id=\"state_component_type_tax_#{at_val.class.name.downcase}\"]", :text => at_val.last_name.nil_to_s+', '+at_val.first_name.nil_to_s)
        elsif at_key =~ /_id$/
          Rails.logger.debug("T state_component_type_taxes_integration_spec edit updated show #{at_key.to_s} - #{at_val.to_s} - Customize ID fields validations")
          if at_key.to_s == 'user_id'
            Rails.logger.debug("T state_component_type_taxes_integration_spec edit updated show #{at_key.to_s} - #{at_val.to_s} - Validate the user_id field")
            find(:xpath, '//span[@id="state_component_type_tax_user"]').text.should =~ /\A#{item1.nil_to_s}\z/
          end
        else
          Rails.logger.debug("T state_component_type_taxes_integration_spec edit updated show #{at_key.to_s} - #{at_val.to_s} - other")
          find(:xpath, "//*[@id=\"state_component_type_tax_#{at_key.to_s}\"]").text.should =~ /^#{at_val.to_s}$/
        end
      end
      updated_item = StateComponentTypeTax.find(item1.id)
      all_attribs.each do | at_key, at_val |
        if at_val.is_a?(ActiveRecord::Base)
          updated_item.send(at_key.to_s).should == at_val.id
        else
          updated_item.send(at_key.to_s).should == at_val
        end
      end
    end
    it 'should be able to show all accessible fields of an item' do
      all_attribs = UserIntegrationHelper.build_attributes(:state_component_type_tax, :state => @state, :job_type => @job_type_reg, :component_type => @component_type, :deactivated => true)
      item1 = StateComponentTypeTax.create!(all_attribs)
      # item1.deactivate
      item1.deactivated?.should be_true
      # visit (state_component_type_tax_path, @tax_type_reg, :show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      visit "/state_component_type_taxes/#{item1.id}?show_deactivated=true" # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.show.header')}$/
      all_attribs.each do | at_key, at_val |
        if at_key.to_s == 'deactivated'
          Rails.logger.debug("T state_component_type_taxes_integration_spec edit updated show - deactivated")
          find(:xpath, "//*[@id=\"state_component_type_tax_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(at_val)}\z/
        elsif at_val.is_a?(TrueClass)
          Rails.logger.debug("T state_component_type_taxes_integration_spec edit updated show #{at_key.to_s} - TrueClass")
          find(:xpath, "//*[@id=\"state_component_type_tax_#{at_key.to_s}\"]").text.should =~ /^true$/
        elsif at_val.is_a?(FalseClass)
          Rails.logger.debug("T state_component_type_taxes_integration_spec edit updated show #{at_key.to_s} - FalseClass")
          find(:xpath, "//*[@id=\"state_component_type_tax_#{at_key.to_s}\"]").text.should =~ /^false$/
        elsif at_key =~ /_id$/
          Rails.logger.debug("T state_component_type_taxes_integration_spec edit updated show #{at_key.to_s} - #{at_val.to_s} - Customize ID fields validations")
          if at_key.to_s == 'user_id'
            Rails.logger.debug("T state_component_type_taxes_integration_spec edit updated show #{at_key.to_s} - #{at_val.to_s} - Validate the user_id field")
            find(:xpath, '//span[@id="state_component_type_tax_user"]').text.should =~ /\A#{item1.nil_to_s}\z/
          end
        else
          Rails.logger.debug("T state_component_type_taxes_integration_spec edit updated show #{at_key.to_s} - #{at_val.to_s} - other")
          find(:xpath, "//*[@id=\"state_component_type_tax_#{at_key.to_s}\"]").text.should =~ /^#{at_val.to_s}$/
        end
      end
    end
  end

  context 'state_component_type_tax layouts - ' do
    before(:each) do
      # @item1 = FactoryGirl.create(:state_component_type_tax, user: @user1)
    end
    context 'Header Show/Hide Deactivated links - ' do
      it 'should send index page with correct show/hide link in table header' do
        visit state_component_type_taxes_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
        page.should have_selector(:xpath, "//th/a", :text =>  I18n.translate('view_action.hide_deactivated') )
        # hide deactivated records
        find(:xpath, "//th/a", :text =>  I18n.translate('view_action.hide_deactivated') ).click
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
        page.should have_selector(:xpath, "//th/a", :text =>  I18n.translate('view_action.show_deactivated') )
        # show deactivated records
        find(:xpath, "//th/a", :text =>  I18n.translate('view_action.show_deactivated') ).click
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
        page.should have_selector(:xpath, "//th/a", :text =>  I18n.translate('view_action.hide_deactivated') )
      end
    end
    context 'should have index/list row links working' do
      before(:each) do
        visit state_component_type_taxes_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
        page.should have_selector(:xpath, "//tr[@id=\"state_component_type_tax_#{@tax_type_reg.id}\"]/td/a", :text =>  I18n.translate('view_action.view') )
        page.should have_selector(:xpath, "//tr[@id=\"state_component_type_tax_#{@tax_type_reg.id}\"]/td/a", :text =>  I18n.translate('view_action.edit') )
      end
      it 'has clickable show button' do
        find(:xpath, "//tr[@id=\"state_component_type_tax_#{@tax_type_reg.id}\"]/td/a", :text =>  I18n.translate('view_action.view') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.show.header')}$/
      end
      it 'has clickable edit button' do
        find(:xpath, "//tr[@id=\"state_component_type_tax_#{@tax_type_reg.id}\"]/td/a", :text =>  I18n.translate('view_action.edit') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.edit.header')}$/
      end
    end
    context 'should have index links working' do
      before(:each) do
        visit state_component_type_taxes_path(:show_deactivated => DB_TRUE.to_s) # to show deactivated records
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('state_component_type_taxes.new.action') )
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('state_component_type_taxes.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.new.header')}$/
      end
    end
    context 'should have new/create links working' do
      before(:each) do
        visit new_state_component_type_tax_path()
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.new.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('state_component_type_taxes.index.action') )
      end
      it 'has clickable index link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('state_component_type_taxes.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
      end
    end
    context 'should have edit/update links working' do
      before(:each) do
        visit edit_state_component_type_tax_path(@tax_type_reg.id)
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.edit.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('state_component_type_taxes.show.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('state_component_type_taxes.index.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('state_component_type_taxes.new.action') )
      end
      it 'has clickable show button' do
        find(:xpath, "//div[@id='content_body_content']/a", :text =>  I18n.translate('state_component_type_taxes.show.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.show.header')}$/
      end
      it 'has clickable index link' do
        # save_and_open_page
        find(:xpath, "//div[@id='content_body_content']/a", :text => I18n.translate('state_component_type_taxes.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body_content']/a", :text => I18n.translate('state_component_type_taxes.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.new.header')}$/
      end
    end
    context 'should have show links working' do
      before(:each) do
        visit state_component_type_tax_path(@tax_type_reg.id)
        # save_and_open_page
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.show.header')}$/
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('state_component_type_taxes.edit.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('state_component_type_taxes.index.action') )
        page.should have_selector(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('state_component_type_taxes.new.action') )
      end
      it 'has clickable edit button' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text =>  I18n.translate('state_component_type_taxes.edit.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.edit.header')}$/
      end
      it 'has clickable index link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('state_component_type_taxes.index.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
      end
      it 'has clickable create new link' do
        find(:xpath, "//div[@id='content_body']/div[@id='content_body_content']/a", :text => I18n.translate('state_component_type_taxes.new.action') ).click
        find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.new.header')}$/
      end
    end
  end
  context 'it should have deactivated actions available and working' do
    before(:each) do
      @item_deact = StateComponentTypeTax.create!(UserIntegrationHelper.build_attributes(:state_component_type_tax, state: @state, job_type: @job_type_reg, component_type: @component_type))
      @item_deact.deactivate
      @item_active = StateComponentTypeTax.create!(UserIntegrationHelper.build_attributes(:state_component_type_non_taxable, state: @state, job_type: @job_type_non_taxable, component_type: @component_type))
    end
    it 'should be able to list all items when show_deactivated is set' do
      item_deact = @item_deact
      item1 = @item_active
      item_deact.deactivated?.should be_true
      visit state_component_type_taxes_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{item1.id}\"]/td[@id=\"state_component_type_tax_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      # find(:xpath, "(//tr[@id=\"state_component_type_tax_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{item1.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{item_deact.id}\"]/td[@id=\"state_component_type_tax_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      # find(:xpath, "(//tr[@id=\"state_component_type_tax_#{item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{item_deact.id}\"]").should have_selector(:xpath, "td/a", :text => "#{I18n.translate('view_action.reactivate')}")
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{item_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
    end
    it 'should be able to list only active items when show_deactivated is off' do
      item_deact = @item_deact
      item1 = item_active = @item_active
      item1.deactivated?.should be_false
      visit state_component_type_taxes_path(:show_deactivated => DB_FALSE.to_s) # dont show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
      page.should have_selector(:xpath, "//tr[@id=\"state_component_type_tax_#{item1.id}\"]")
      page.should_not have_selector(:xpath, "//tr[@id=\"state_component_type_tax_#{item_deact.id}\"]")
    end
    it 'should not see deactivate option on a deactivated item' do
      item_deact = @item_deact
      item1 = item_active = @item_active
      visit state_component_type_taxes_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{item_deact.id}\"]/td[@id=\"state_component_type_tax_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{item_deact.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.reactivate')}\"]")
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{item_deact.id}\"]").should_not have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
    end
    it 'should not see reactivate option on an active item' do
      item_deact = @item_deact
      item1 = item_active = @item_active
      visit state_component_type_taxes_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{item_active.id}\"]/td[@id=\"state_component_type_tax_#{item_active.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{item_active.id}\"]").should_not have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.reactivate')}\"]")
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{item_active.id}\"]").should have_selector(:xpath, "td/a[text()=\"#{I18n.translate('view_action.deactivate')}\"]")
    end
    it 'should not see delete on an active item' do
      item_active = @item_active
      visit state_component_type_taxes_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{item_active.id}\"]/td[@id=\"state_component_type_tax_#{item_active.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{item_active.id}\"]").should_not have_selector(:xpath, "td/a[@data-method=\"delete\"]")
    end
    it 'should see delete on a deactivated item' do
      item_deact = @item_deact
      item1 = item_active = @item_active
      visit state_component_type_taxes_path(:show_deactivated => DB_TRUE.to_s) # show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{item_deact.id}\"]/td[@id=\"state_component_type_tax_#{item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{item_deact.id}\"]").should have_selector(:xpath, "td/a[@data-method=\"delete\"]")
    end
    it 'should GET show the active item as not deactivated' do
      item1 =  @item_active
      item1.deactivated?.should be_false
      visit state_component_type_tax_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.show.header')}$/
      find(:xpath, '//*[@id="state_component_type_tax_deactivated"]').text.should_not =~ /\A\s*\z/
      find(:xpath, '//*[@id="state_component_type_tax_deactivated"]').text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
    end
    it 'should see the deactivated field in edit' do
      item_deact = @item_deact
      item1 = item_active = @item_active
      item1.deactivated?.should be_false
      visit edit_state_component_type_tax_path (item1.id)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.edit.header')}$/
      page.should_not have_selector(:xpath, "//*[@id=\"state_component_type_tax_deactivated_true\" and @checked]")
      page.should have_selector(:xpath, "//*[@id=\"state_component_type_tax_deactivated_false\" and @checked]")
    end
    it 'controller should list items with deactivate/reactivate action/link/button depending upon status' do
      item_deact = @item_deact
      item1 = item_active = @item_active
      item1.deactivated?.should be_false
      StateComponentTypeTax.count.should > 1
      visit state_component_type_taxes_path(:show_deactivated => DB_TRUE.to_s) # need to show deactivated records for this test
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{item1.id}\"]/td[@id=\"state_component_type_tax_#{item1.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"state_component_type_tax_#{item1.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{@item_deact.id}\"]/td[@id=\"state_component_type_tax_#{@item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      find(:xpath, "(//tr[@id=\"state_component_type_tax_#{@item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{@item_deact.id}\"]/td/a[@data-method=\"delete\"]").text.should =~ /\A#{I18n.translate('view_action.delete')}\z/
    end
    it 'Update action should allow a change from deactivated to active' do
      @updated_item = StateComponentTypeTax.find(@item_deact.id)
      @updated_item.deactivated?.should be_true
      @num_items = StateComponentTypeTax.count
      visit ("/state_component_type_taxes/#{@item_deact.id}/edit?show_deactivated=true")
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.edit.header')}$/
      page.should have_selector(:xpath, "//*[@id=\"state_component_type_tax_deactivated_true\" and @checked]")
      page.should_not have_selector(:xpath, "//*[@id=\"state_component_type_tax_deactivated_false\" and @checked]")
      within(".edit_state_component_type_tax") do
        page.choose("state_component_type_tax_deactivated_false")
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('home.errors.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should_not =~ /^#{I18n.translate('state_component_type_taxes.edit.header')}$/
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => @updated_item.class.name, :id => @updated_item.id )}/
      StateComponentTypeTax.count.should == (@num_items)
      find(:xpath, "//*[@id=\"state_component_type_tax_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      @updated_item = StateComponentTypeTax.find(@item_deact.id)
      @updated_item.deactivated?.should be_false
    end
    it 'Update action should allow a change from active to deactivated' do
      @item_active.deactivated?.should be_false
      @num_items = StateComponentTypeTax.count
      # visit edit_state_component_type_tax_path (@item_active.id)
      visit ("/state_component_type_taxes/#{@item_active.id}/edit?show_deactivated=true")
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.edit.header')}$/
      page.should_not have_selector(:xpath, "//*[@id=\"state_component_type_tax_deactivated_true\" and @checked]")
      page.should have_selector(:xpath, "//*[@id=\"state_component_type_tax_deactivated_false\" and @checked]")
      within(".edit_state_component_type_tax") do
        page.choose("state_component_type_tax_deactivated_true")
        # select I18n.translate('view_field_value.deactivated'), :from => 'state_component_type_tax_deactivated'
        find(:xpath, '//input[@type="submit"]').click
      end
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'update', :obj => @item_active.class.name, :id => @item_active.id )}$/
      StateComponentTypeTax.count.should == (@num_items)
      find(:xpath, "//*[@id=\"state_component_type_tax_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(true)}\z/
      @updated_item = StateComponentTypeTax.find(@item_active.id)
      @updated_item.deactivated?.should be_true
    end
    it 'should allow a item to be deactivated from the index page' do
      @item_active.deactivated?.should be_false
      @num_items = StateComponentTypeTax.count
      @num_items.should > 1
      visit state_component_type_taxes_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{@item_active.id}\"]/td[@id=\"state_component_type_tax_#{@item_active.id}_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"state_component_type_tax_#{@item_active.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{@item_active.id}\"]//a", :text => I18n.translate('view_action.deactivate') ).click
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'deactivate', :obj => @item_active.class.name, :id => @item_active.id )}$/
      StateComponentTypeTax.count.should == (@num_items)
      @updated_item = StateComponentTypeTax.find(@item_active.id)
      @updated_item.deactivated?.should be_true
    end
    it 'should allow a item to be reactivated from the index page' do
      @item_active.deactivated?.should be_false
      @num_items = StateComponentTypeTax.count
      @num_items.should > 1
      visit state_component_type_taxes_path(:show_deactivated => DB_TRUE.to_s)
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{@item_deact.id}\"]/td[@id=\"state_component_type_tax_#{@item_deact.id}_deactivated\"]").text.should =~ /\A#{I18n.translate('view_field_value.deactivated')}\z/
      find(:xpath, "(//tr[@id=\"state_component_type_tax_#{@item_deact.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.reactivate')}\z/
      # click on reactivate button of deactivated item
      find(:xpath, "//tr[@id=\"state_component_type_tax_#{@item_deact.id}\"]//a", :text => I18n.translate('view_action.reactivate') ).click
      # save_and_open_page
      page.driver.status_code.should be 200
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.show.header')}$/
      find(:xpath, '//*[@id="header_status"]/p[@class="notice"]').text.should =~
        /^#{I18n.translate('errors.success_method_obj_id', :method => 'reactivate', :obj => @item_active.class.name, :id => @item_deact.id )}$/
      StateComponentTypeTax.count.should == (@num_items)
      find(:xpath, "//*[@id=\"state_component_type_tax_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      @updated_item = StateComponentTypeTax.find(@item_active.id)
      @updated_item.deactivated?.should be_false
    end
    it 'should not list deactivated items by state_component_type_tax_type' do
      @item_active.deactivated?.should be_false
      StateComponentTypeTax.count.should > 1
      # get state_component_type_taxes_path
      # response.status.should be(200)
      visit state_component_type_taxes_path()
      page.driver.status_code.should be 200
      # save_and_open_page
      find(:xpath, '//*[@id="header_tagline_page_header"]').text.should =~ /^#{I18n.translate('state_component_type_taxes.index.header')}$/
      # find(:xpath, "//tr[@id=\"state_component_type_tax_#{@item_active.id}\"]/td[@class=\"state_component_type_tax_deactivated\"]").text.should =~ /\A#{I18n.is_deactivated_or_not(false)}\z/
      find(:xpath, "(//tr[@id=\"state_component_type_tax_#{@item_active.id}\"]//a)[3]").text.should =~ /\A#{I18n.translate('view_action.deactivate')}\z/
      page.should_not have_selector(:xpath, "//tr[@id=\"state_component_type_tax_#{@item_deact.id}\"]/td[@class=\"state_component_type_tax_deactivated\"]", :text => I18n.is_deactivated_or_not(true) )
    end
  end
end
