require 'spec_helper'
include SpecHelper

# it 'should have a StateComponentTypeTax table to store the default tax rate by State and Component Type'

describe StateComponentTypeTax do
  # context 'it should validate presence tests' do
  #   it { should validate_presence_of :state }
  #   it { should validate_presence_of :state_id }
  #   it { should validate_presence_of :job_type }
  #   it { should validate_presence_of :job_type_id }
  #   it { should validate_presence_of :component_type }
  #   it { should validate_presence_of :component_type_id }
  #   it { should validate_presence_of :tax_percent }
  # end
  context 'it should have crud actions available and working' do
    before(:each) do
      @state = State.create!(FactoryGirl.attributes_for(:state))
      @job_type_reg = JobType.create!(FactoryGirl.attributes_for(:job_type))
      Rails.logger.debug("T @job_type_reg : #{@job_type_reg.inspect.to_s}")
      @job_type_non_taxable = JobType.create!(FactoryGirl.attributes_for(:job_type))
      @component_type = ComponentType.create!(FactoryGirl.attributes_for(:component_type))
      @tax_type_attribs = UserIntegrationHelper.build_attributes(:state_component_type_tax, state: @state, job_type: @job_type_reg, component_type: @component_type)
      @tax_type_req_attribs = @tax_type_attribs.clone.keep_if {|k,v| SpecHelper::REQUIRED_STATE_COMPONENT_TYPE_TAX_FIELDS.include?(k.to_sym)}
      @tax_type_reg = StateComponentTypeTax.create!(UserIntegrationHelper.build_attributes(:state_component_type_tax, state: @state, job_type: @job_type_reg, component_type: @component_type))
      @tax_type_non_taxable = StateComponentTypeTax.create!(UserIntegrationHelper.build_attributes(:state_component_type_non_taxable, state: @state, job_type: @job_type_non_taxable, component_type: @component_type))
      Rails.logger.debug("T state_component_type_taxes_integration_spec initial creations done")
    end
    it "should raise an error create user with no attributes" do
      num_items = StateComponentTypeTax.count
      lambda {StateComponentTypeTax.create!()}.should raise_error(ActiveRecord::RecordInvalid)
      StateComponentTypeTax.count.should == num_items
    end    
    it "should not create user when created with no attributes" do
      num_items = StateComponentTypeTax.count
      item = StateComponentTypeTax.create()
      StateComponentTypeTax.count.should == num_items
    end
    it 'should create StateComponentTypeTax when created with the minimum_attributes' do
      num_items = StateComponentTypeTax.count
      attribs = @tax_type_req_attribs
      Rails.logger.debug("T required attributes: #{attribs.inspect.to_s}")
      item1 = StateComponentTypeTax.create!(@tax_type_attribs)
      item1.should be_instance_of(StateComponentTypeTax)
      # loop through all of the attributes used to create this item to see if in created item
      attribs.each do | key, val |
        Rails.logger.debug("T state_component_type_tax_spec component_types_min item1.send(#{key}):#{item1.send(key)}")
        item1.send(key).should == val
      end
      item1.id.should_not be_nil
      item1.errors.count.should == 0
      StateComponentTypeTax.count.should == num_items + 1
    end   
    it 'should not create component_types when created missing one of the minimum_attributes' do
      num_items = StateComponentTypeTax.count
      attribs = @tax_type_req_attribs
      Rails.logger.debug ("T state_component_type_tax_spec attribs (min) = #{attribs.inspect.to_s}")
      attribs.each do | atrkey, atrval |
        Rails.logger.debug("T state_component_type_tax_spec component_types_min - try to create item without key:#{atrkey}")
        attribs_missing = attribs.reject{|itekey, iteval| itekey == atrkey}
        item1 = StateComponentTypeTax.create(attribs_missing)  # remove attrib key from this item create
        item1.should be_instance_of(StateComponentTypeTax)
        # if we care what values are placed in an error object --
        # loop through all of the attributes used to create this item to see if in created item
        attribs_missing.each do | key, val |
          Rails.logger.debug("T state_component_type_tax_spec component_types_min item1.send(#{key}):#{item1.send(key)}")
          item1.send(key).should == val
        end
        # item1.send(atrkey).should == nil
        item1.id.should be_nil
        item1.errors.count.should > 0
        StateComponentTypeTax.count.should == num_items
      end
    end
  end
  context 'it should have deactivated actions available and working' do
    before(:each) do
      @state = State.create!(FactoryGirl.attributes_for(:state))
      @job_type_reg = JobType.create!(FactoryGirl.attributes_for(:job_type))
      Rails.logger.debug("T @job_type_reg : #{@job_type_reg.inspect.to_s}")
      @job_type_non_taxable = JobType.create!(FactoryGirl.attributes_for(:job_type))
      @component_type = ComponentType.create!(FactoryGirl.attributes_for(:component_type))
      @tax_type_attribs = UserIntegrationHelper.build_attributes(:state_component_type_tax, state: @state, job_type: @job_type_reg, component_type: @component_type)
      Rails.logger.debug("T tax_type_attribs : #{@tax_type_attribs.inspect.to_s}")
      @tax_type_reg = StateComponentTypeTax.create!(UserIntegrationHelper.build_attributes(:state_component_type_tax, state: @state, job_type: @job_type_reg, component_type: @component_type))
      @tax_type_non_taxable = StateComponentTypeTax.create!(UserIntegrationHelper.build_attributes(:state_component_type_non_taxable, state: @state, job_type: @job_type_non_taxable, component_type: @component_type))
      Rails.logger.debug("T state_component_type_taxes_integration_spec initial creations done")
    end
    it 'should be able to deactivate an active record' do
      num_items = StateComponentTypeTax.count
      attribs = @tax_type_attribs
      item1 = StateComponentTypeTax.create(attribs)
      item1.deactivated.should be_false
      StateComponentTypeTax.count.should == num_items + 1
      item1.deactivate
      item1.deactivated.should be_true
      item_found = StateComponentTypeTax.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true     
    end
    it 'should not be able to deactivate a deactivated record' do
      num_items = StateComponentTypeTax.count
      attribs = @tax_type_attribs
      item1 = StateComponentTypeTax.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item_found = StateComponentTypeTax.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true 
      item_found.errors.count.should == 0
      item_found.deactivate
      item_found.errors.count.should > 0
      item_found2 = StateComponentTypeTax.find(item_found.id)
      item_found2.should_not be_nil
      item_found2.deactivated.should be_true 
    end
    it 'should be able to reactivate a deactivated record' do
      num_items = StateComponentTypeTax.count
      attribs = @tax_type_attribs
      item1 = StateComponentTypeTax.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item_found = StateComponentTypeTax.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true 
      item_found.errors.count.should == 0
      item_found.reactivate
      item_found.errors.count.should == 0
      item_found2 = StateComponentTypeTax.find(item_found.id)
      item_found2.should_not be_nil
      item_found2.deactivated.should be_false
    end
    it 'should not be able to reactivate an active record' do
      num_items = StateComponentTypeTax.count
      attribs = @tax_type_attribs
      item1 = StateComponentTypeTax.create(attribs)
      item1.deactivated.should be_false
      item1.errors.count.should == 0
      item1.reactivate
      item1.errors.count.should > 0
      item1.deactivated.should be_false
      item_found = StateComponentTypeTax.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_false 
    end
    it 'should be able to destroy a deactivated record' do
      num_items = StateComponentTypeTax.count
      attribs = @tax_type_attribs
      item1 = StateComponentTypeTax.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item1.errors.count.should == 0
      item1.destroy
      item1.errors.count.should == 0
      item1.deactivated.should be_true
      lambda{StateComponentTypeTax.find(item1.id)}.should raise_error(ActiveRecord::RecordNotFound)
    end
    it 'should not be able to destroy an active record' do
      num_items = StateComponentTypeTax.count
      attribs = @tax_type_attribs
      item1 = StateComponentTypeTax.create(attribs)
      item1.deactivated.should be_false
      item1.errors.count.should == 0
      item1.destroy
      item1.errors.count.should > 0
      item1.deactivated.should be_false
      item_found = StateComponentTypeTax.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_false 
    end
  end
  context 'it should be associated with component_types' do
    before(:each) do
      @state = State.create!(FactoryGirl.attributes_for(:state))
      @job_type = JobType.create!(FactoryGirl.attributes_for(:job_type))
      Rails.logger.debug("T @job_type : #{@job_type.inspect.to_s}")
      @component_type = ComponentType.create!(FactoryGirl.attributes_for(:component_type))
      @tax_type_attribs = UserIntegrationHelper.build_attributes(:state_component_type_tax, state: @state, job_type: @job_type, component_type: @component_type)
      Rails.logger.debug("T state_component_type_taxes_integration_spec initial creations done")
    end
    it 'should not allow destroy of component_type if there are state_component_type_tax records' do
      StateComponentTypeTax.create(@tax_type_attribs)
      @component_type.state_component_type_taxes.length.should == 1
      num_parent = ComponentType.count
      @component_type.deactivate()
      @component_type.destroy()
      @component_type.errors.count.should > 0
      ComponentType.count.should == num_parent
    end
    it 'should not allow destroy of state if there are state_component_type_tax records' do
      StateComponentTypeTax.create(@tax_type_attribs)
      @state.state_component_type_taxes.length.should == 1
      num_parent = State.count
      # @state.deactivate()
      # lambda {@state.destroy()}.should raise_error(ActiveRecord::DeleteRestrictionError)
      @state.destroy()
      @state.errors.count.should > 0
      State.count.should == num_parent
    end
    it 'should not allow destroy of job_type if there are state_component_type_tax records' do
      StateComponentTypeTax.create(@tax_type_attribs)
      @job_type.state_component_type_taxes.length.should == 1
      num_parent = JobType.count
      @job_type.deactivate()
      # lambda {@job_type.destroy()}.should raise_error(ActiveRecord::DeleteRestrictionError)
      @job_type.destroy()
      @job_type.errors.count.should > 0
      JobType.count.should == num_parent
    end
    it 'should allow destroy of component_type if there are no state_component_type_tax records' do
      num_parent = ComponentType.count
      @component_type.deactivate()
      @component_type.destroy()
      @component_type.errors.count.should == 0
      ComponentType.count.should == num_parent - 1
    end
    it 'should allow destroy of state if there are no state_component_type_tax records' do
      num_parent = State.count
      # @state.deactivate()
      @state.destroy()
      @state.errors.count.should == 0
      State.count.should == num_parent - 1
    end
    it 'should allow destroy of job_type if there are no state_component_type_tax records' do
      num_parent = JobType.count
      @job_type.deactivate()
      @job_type.destroy()
      @job_type.errors.count.should == 0
      JobType.count.should == num_parent - 1
    end
  end
end
