require 'spec_helper'

describe AssemblyComponent do
  context 'it should have crud actions available and working' do
    it "should raise an error create user with no attributes" do
      num_items = AssemblyComponent.count
      lambda {AssemblyComponent.create!()}.should raise_error(ActiveRecord::RecordInvalid)
      AssemblyComponent.count.should == num_items
    end    
    it "should not create user when created with no attributes" do
      num_items = AssemblyComponent.count
      item = AssemblyComponent.create()
      AssemblyComponent.count.should == num_items
    end
    it 'should have tests accessible attributes match the accessible attributes for the model' do
      attribs = FactoryGirl.build(:assembly_component_accessible)._accessible_attributes
      # Rails.logger.debug("T component_create.attributes: #{attribs.inspect.to_s}")
      # Rails.logger.debug("T attribs[:default]: #{ attribs[:default].inspect.to_s}")
      attribs_whitelist = attribs[:default]
      # Rails.logger.debug("T attribs_whitelist: #{attribs_whitelist.inspect.to_s}")
      acc_attribs = generate_assembly_component_accessible_attributes()
      # Rails.logger.debug("T :generate_assembly_component_accessible_attributes: #{acc_attribs.inspect.to_s}")
      attribs_whitelist.size.should == acc_attribs.size
      attribs_whitelist.each do |key, val|
        Rails.logger.debug ("T Accessible attribute #{key.to_s} = #{acc_attribs[key.to_sym].inspect.to_s}")
        acc_attribs[key.to_sym].should_not be_nil
      end
    end
    it 'should create user when created with the minimum_attributes' do
      num_items = AssemblyComponent.count
      attribs = generate_assembly_component_accessible_attributes()
      Rails.logger.debug("T :generate_assembly_component_accessible_attributes: #{attribs.inspect.to_s}")
      item1 = AssemblyComponent.create(attribs)
      item1.should be_instance_of(AssemblyComponent)
      # loop through all of the attributes used to create this item to see if in created item
      attribs.each do | key, val |
        Rails.logger.debug("T assembly_component_spec item1.send(#{key}):#{item1.send(key)}")
        item1.send(key).should == val
      end
      item1.id.should_not be_nil
      item1.errors.count.should == 0
      AssemblyComponent.count.should == num_items + 1
    end   
    it 'should not create component_types when created missing one of the minimum_attributes' do
      num_items = AssemblyComponent.count
      attribs = generate_assembly_component_min_attributes()
      attribs.each do | atrkey, atrval |
        Rails.logger.debug("T assembly_component_spec - try to create item without key:#{atrkey}")
        attribs_missing = attribs.reject{|itekey, iteval| itekey == atrkey}
        item1 = AssemblyComponent.create(attribs_missing)  # remove attrib key from this item create
        item1.should be_instance_of(AssemblyComponent)
        # if we care what values are placed in an error object --
        # loop through all of the attributes used to create this item to see if in created item
        attribs_missing.each do | key, val |
          Rails.logger.debug("T assembly_component_spec item1.send(#{key}):#{item1.send(key)}")
          item1.send(key).should == val
        end
        # item1.send(atrkey).should == nil
        item1.id.should be_nil
        item1.errors.count.should > 0
        AssemblyComponent.count.should == num_items
      end
    end   
  end
  context 'it should have deactivated actions available and working' do
    it 'should be able to deactivate an active record' do
      num_items = AssemblyComponent.count
      attribs = generate_assembly_component_accessible_attributes()
      item1 = AssemblyComponent.create(attribs)
      item1.deactivated.should be_false
      AssemblyComponent.count.should == num_items + 1
      item1.deactivate
      item1.deactivated.should be_true
      item_found = AssemblyComponent.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true     
    end
    it 'should not be able to deactivate a deactivated record' do
      num_items = AssemblyComponent.count
      attribs = generate_assembly_component_accessible_attributes()
      item1 = AssemblyComponent.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item_found = AssemblyComponent.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true 
      item_found.errors.count.should == 0
      item_found.deactivate
      item_found.errors.count.should > 0
      item_found2 = AssemblyComponent.find(item_found.id)
      item_found2.should_not be_nil
      item_found2.deactivated.should be_true 
    end
    it 'should be able to reactivate a deactivated record' do
      num_items = AssemblyComponent.count
      attribs = generate_assembly_component_accessible_attributes()
      item1 = AssemblyComponent.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item_found = AssemblyComponent.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true 
      item_found.errors.count.should == 0
      item_found.reactivate
      item_found.errors.count.should == 0
      item_found2 = AssemblyComponent.find(item_found.id)
      item_found2.should_not be_nil
      item_found2.deactivated.should be_false
    end
    it 'should not be able to reactivate an active record' do
      num_items = AssemblyComponent.count
      attribs = generate_assembly_component_accessible_attributes()
      item1 = AssemblyComponent.create(attribs)
      item1.deactivated.should be_false
      item1.errors.count.should == 0
      item1.reactivate
      item1.errors.count.should > 0
      item1.deactivated.should be_false
      item_found = AssemblyComponent.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_false 
    end
    it 'should be able to destroy a deactivated record' do
      num_items = AssemblyComponent.count
      attribs = generate_assembly_component_accessible_attributes()
      item1 = AssemblyComponent.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item1.errors.count.should == 0
      item1.destroy
      item1.errors.count.should == 0
      item1.deactivated.should be_true
      lambda{AssemblyComponent.find(item1.id)}.should raise_error(ActiveRecord::RecordNotFound)
    end
    it 'should not be able to destroy an active record' do
      num_items = AssemblyComponent.count
      attribs = generate_assembly_component_accessible_attributes()
      item1 = AssemblyComponent.create(attribs)
      item1.deactivated.should be_false
      item1.errors.count.should == 0
      item1.destroy
      item1.errors.count.should > 0
      item1.deactivated.should be_false
      item_found = AssemblyComponent.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_false 
    end
  end
  context 'it should be associated with component_types' do
    before (:each) do
      @parent = FactoryGirl.create(:assembly_create)
      @component_type = FactoryGirl.create(:component_type)
      @component1 = FactoryGirl.create(:component_min_create, component_type: @component_type)
      @component2 = FactoryGirl.create(:component_min_create, component_type: @component_type)
    end
    it 'should have uniqueness by assembly and component' do
      num_items = AssemblyComponent.count
      attribs = generate_assembly_component_accessible_attributes()
      item1 = AssemblyComponent.create(attribs)
      AssemblyComponent.count.should == num_items + 1
      item2 = AssemblyComponent.create(attribs)
      item2.errors.count.should > 0
      AssemblyComponent.count.should == num_items + 1
    end
    it 'should not allow destroy of assembly if there are assembly_components' do
      FactoryGirl.create(:assembly_component_create, assembly: @parent, :component => @component1)
      FactoryGirl.create(:assembly_component_create, assembly: @parent, :component => @component2)
      @parent.assembly_components.length.should == 2
      num_assemblies = Assembly.count
      @parent.deactivate()
      @parent.destroy()
      Assembly.count.should == num_assemblies
      # @parent.errors.count.should > 0
    end
    it 'should allow destroy of component_type if there are no assembly_components' do
      num_parent = Assembly.count
      @parent.deactivate()
      @parent.destroy()
      @parent.errors.count.should == 0
      Assembly.count.should == num_parent - 1
    end
  end
end
