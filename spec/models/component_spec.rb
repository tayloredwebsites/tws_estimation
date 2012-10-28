require 'spec_helper'

describe Component do
  context 'it should have crud actions available and working' do
    it "should raise an error create user with no attributes" do
      num_items = Component.count
      lambda {Component.create!()}.should raise_error(ActiveRecord::RecordInvalid)
      Component.count.should == num_items
    end    
    it "should not create user when created with no attributes" do
      num_items = Component.count
      item = Component.create()
      Component.count.should == num_items
    end
    it 'should have tests accessible attributes match the accessible attributes for the model' do
      attribs = FactoryGirl.build(:component_create)._accessible_attributes
      # Rails.logger.debug("T component_create.attributes: #{attribs.inspect.to_s}")
      # Rails.logger.debug("T attribs[:default]: #{ attribs[:default].inspect.to_s}")
      attribs_whitelist = attribs[:default]
      # Rails.logger.debug("T attribs_whitelist: #{attribs_whitelist.inspect.to_s}")
      acc_attribs = generate_component_accessible_attributes()
      # Rails.logger.debug("T generate_component_accessible_attributes: #{acc_attribs.inspect.to_s}")
      attribs_whitelist.each do |key, val|
        Rails.logger.debug ("T Accessible attribute #{key.to_s}/#{val.to_s} = #{acc_attribs[key.to_sym].inspect.to_s}")
        acc_attribs[key.to_sym].should_not be_nil
      end
      attribs_whitelist.size.should == acc_attribs.size
    end
    it 'should create Component when created with the minimum_attributes' do
      num_items = Component.count
      attribs = generate_component_accessible_attributes()
      Rails.logger.debug("T generate_component_accessible_attributes: #{attribs.inspect.to_s}")
      item1 = Component.create(attribs)
      item1.should be_instance_of(Component)
      # loop through all of the attributes used to create this item to see if in created item
      attribs.each do | key, val |
        Rails.logger.debug("T component_type_spec component_types_min item1.send(#{key}):#{item1.send(key)}")
        item1.send(key).should == val
      end
      item1.id.should_not be_nil
      item1.errors.count.should == 0
      Component.count.should == num_items + 1
    end   
    it 'should not create component_types when created missing one of the minimum_attributes' do
      num_items = Component.count
      attribs = generate_component_min_attributes()
      attribs.each do | atrkey, atrval |
        Rails.logger.debug("T component_type_spec component_types_min - try to create item without key:#{atrkey}")
        attribs_missing = attribs.reject{|itekey, iteval| itekey == atrkey}
        item1 = Component.create(attribs_missing)  # remove attrib key from this item create
        item1.should be_instance_of(Component)
        # if we care what values are placed in an error object --
        # loop through all of the attributes used to create this item to see if in created item
        attribs_missing.each do | key, val |
          Rails.logger.debug("T component_type_spec component_types_min item1.send(#{key}):#{item1.send(key)}")
          item1.send(key).should == val
        end
        # item1.send(atrkey).should == nil
        item1.id.should be_nil
        item1.errors.count.should > 0
        Component.count.should == num_items
      end
    end
    it 'should only allow updates of valid operation operands and scopes' do
      Component.count.should == 0
      attribs = generate_component_min_attributes()
      Rails.logger.debug("TTTTT Component attribs = #{attribs.inspect.to_s}")
      item1 = Component.create!(attribs)  # create component with no additional attributes
      item1.id.should_not be_nil
      item1.errors.count.should == 0
      Component.count.should == 1
      # it 'should allow nil grid_operand, nil grid_scope and nil grid_subtotal'
      item1.grid_operand.should == nil
      item1.grid_scope.should == nil
      item1.grid_subtotal.should == nil
      VALID_GRID_OPERANDS.each do |operand_key, operand_val|
        VALID_GRID_SCOPES.each do |scope_key, scope_val|
          Rails.logger.debug("T Testing operand: #{operand_key}, scope: #{scope_key}")
          attribs_work = attribs.merge({:grid_operand => operand_key, :grid_scope => scope_key})
          Rails.logger.debug("T Testing attribs_work: #{attribs_work.inspect.to_s}")
          item1.update_attributes!(attribs_work)  # create component with additional attributes
          Rails.logger.debug("T Testing attribute item1.send(:grid_operand):#{item1.send(:grid_operand)} should == #{operand_key}")
          item1.send(:grid_operand).should == operand_key
          Rails.logger.debug("T Testing attribute item1.send(:grid_scope):#{item1.send(:grid_scope)} should == #{scope_key}")
          item1.send(:grid_scope).should == scope_key
        end
      end
      attribs_work = attribs.merge({:grid_operand => '@', :grid_scope => 'Q'})
      # try to create component with invalid attributes
      lambda {item1.update_attributes!(attribs_work)}.should raise_error(ActiveRecord::RecordInvalid)
      # item1.update_attributes!(attribs_work)  # create component with additional attributes
      updated_item = Component.find(item1.id)
      Rails.logger.debug("T Testing attribute updated_item.send(:grid_operand):#{item1.send(:grid_operand)} should_not == '@'")
      updated_item.send(:grid_operand).should_not == '@'
      Rails.logger.debug("T Testing attribute updated_item.send(:grid_scope):#{item1.send(:grid_scope)} should_not == 'Q'")
      updated_item.send(:grid_scope).should_not == 'Q'
    end
  end
  context 'it should have deactivated actions available and working' do
    it 'should be able to deactivate an active record' do
      num_items = Component.count
      attribs = generate_component_accessible_attributes()
      item1 = Component.create(attribs)
      item1.deactivated.should be_false
      Component.count.should == num_items + 1
      item1.deactivate
      item1.deactivated.should be_true
      item_found = Component.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true     
    end
    it 'should not be able to deactivate a deactivated record' do
      num_items = Component.count
      attribs = generate_component_accessible_attributes()
      item1 = Component.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item_found = Component.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true 
      item_found.errors.count.should == 0
      item_found.deactivate
      item_found.errors.count.should > 0
      item_found2 = Component.find(item_found.id)
      item_found2.should_not be_nil
      item_found2.deactivated.should be_true 
    end
    it 'should be able to reactivate a deactivated record' do
      num_items = Component.count
      attribs = generate_component_accessible_attributes()
      item1 = Component.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item_found = Component.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true 
      item_found.errors.count.should == 0
      item_found.reactivate
      item_found.errors.count.should == 0
      item_found2 = Component.find(item_found.id)
      item_found2.should_not be_nil
      item_found2.deactivated.should be_false
    end
    it 'should not be able to reactivate an active record' do
      num_items = Component.count
      attribs = generate_component_accessible_attributes()
      item1 = Component.create(attribs)
      item1.deactivated.should be_false
      item1.errors.count.should == 0
      item1.reactivate
      item1.errors.count.should > 0
      item1.deactivated.should be_false
      item_found = Component.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_false 
    end
    it 'should be able to destroy a deactivated record' do
      num_items = Component.count
      attribs = generate_component_accessible_attributes()
      item1 = Component.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item1.errors.count.should == 0
      item1.destroy
      item1.errors.count.should == 0
      item1.deactivated.should be_true
      lambda{Component.find(item1.id)}.should raise_error(ActiveRecord::RecordNotFound)
    end
    it 'should not be able to destroy an active record' do
      num_items = Component.count
      attribs = generate_component_accessible_attributes()
      item1 = Component.create(attribs)
      item1.deactivated.should be_false
      item1.errors.count.should == 0
      item1.destroy
      item1.errors.count.should > 0
      item1.deactivated.should be_false
      item_found = Component.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_false 
    end
  end
  context 'it should be associated with component_types' do
    before (:each) do
      @parent = FactoryGirl.create(:component_type)
      @default = FactoryGirl.create(:default)
    end
    it 'should not allow destroy of component_type if there are components' do
      FactoryGirl.create(:component_min_create, component_type: @parent)
      FactoryGirl.create(:component_create, component_type: @parent, default: @default)
      @parent.components.length.should == 2
      num_parent = ComponentType.count
      @parent.deactivate()
      @parent.destroy()
      @parent.errors.count.should > 0
      ComponentType.count.should == num_parent
    end
    it 'should allow destroy of component_type if there are components' do
      num_parent = ComponentType.count
      @parent.deactivate()
      @parent.destroy()
      @parent.errors.count.should == 0
      ComponentType.count.should == num_parent - 1
    end
  end
end
