require 'spec_helper'

describe Assembly do
  context 'it should have crud actions available and working' do
    it "should raise an error create item with no attributes" do
      num_items = Assembly.count
      lambda {Assembly.create!()}.should raise_error(ActiveRecord::RecordInvalid)
      Assembly.count.should == num_items
    end    
    it "should not create item when created with no attributes" do
      num_items = Assembly.count
      item = Assembly.create()
      Assembly.count.should == num_items
    end    
    it 'should create item when created with the minimum_attributes' do
      num_items = Assembly.count
      attribs = FactoryGirl.attributes_for(:assembly_min_create)
      item1 = Assembly.create(attribs)
      item1.should be_instance_of(Assembly)
      # loop through all of the attributes used to create this item to see if in created item
      attribs.each do | key, val |
        Rails.logger.debug("T assembly_spec assemblies_min item1.send(#{key}):#{item1.send(key)}")
        item1.send(key).should == val
      end
      item1.id.should_not be_nil
      item1.errors.count.should == 0
      Assembly.count.should == num_items + 1
    end   
    it 'should not create assemblies when created missing one of the minimum_attributes' do
      num_items = Assembly.count
      attribs = FactoryGirl.attributes_for(:assembly_min_create)
      attribs.each do | atrkey, atrval |
        Rails.logger.debug("T assembly_spec assemblies_min - try to create item without key:#{atrkey}")
        attribs_missing = attribs.reject{|itekey, iteval| itekey == atrkey}
        item1 = Assembly.create(attribs_missing)  # remove attrib key from this item create
        item1.should be_instance_of(Assembly)
        # if we care what values are placed in an error object --
        # loop through all of the attributes used to create this item to see if in created item
        attribs_missing.each do | key, val |
          Rails.logger.debug("T assembly_spec assemblies_min item1.send(#{key}):#{item1.send(key)}")
          item1.send(key).should == val
        end
        item1.send(atrkey).should == ''
        item1.id.should be_nil
        item1.errors.count.should > 0
        Assembly.count.should == num_items
      end
      
    end   
  end
  context 'it should have deactivated actions available and working' do
    it 'should be able to deactivate an active record' do
      num_items = Assembly.count
      attribs = FactoryGirl.attributes_for(:assembly_create)
      item1 = Assembly.create(attribs)
      item1.deactivated.should be_false
      Assembly.count.should == num_items + 1
      item1.deactivate
      item1.deactivated.should be_true
      item_found = Assembly.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true     
    end
    it 'should not be able to deactivate a deactivated record' do
      num_items = Assembly.count
      attribs = FactoryGirl.attributes_for(:assembly_create)
      item1 = Assembly.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item_found = Assembly.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true 
      item_found.errors.count.should == 0
      item_found.deactivate
      item_found.errors.count.should > 0
      item_found2 = Assembly.find(item_found.id)
      item_found2.should_not be_nil
      item_found2.deactivated.should be_true 
    end
    it 'should be able to reactivate a deactivated record' do
      num_items = Assembly.count
      attribs = FactoryGirl.attributes_for(:assembly_create)
      item1 = Assembly.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item_found = Assembly.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true 
      item_found.errors.count.should == 0
      item_found.reactivate
      item_found.errors.count.should == 0
      item_found2 = Assembly.find(item_found.id)
      item_found2.should_not be_nil
      item_found2.deactivated.should be_false
    end
    it 'should not be able to reactivate an active record' do
      num_items = Assembly.count
      attribs = FactoryGirl.attributes_for(:assembly_create)
      item1 = Assembly.create(attribs)
      item1.deactivated.should be_false
      item1.errors.count.should == 0
      item1.reactivate
      item1.errors.count.should > 0
      item1.deactivated.should be_false
      item_found = Assembly.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_false 
    end
    it 'should be able to destroy a deactivated record' do
      num_items = Assembly.count
      attribs = FactoryGirl.attributes_for(:assembly_create)
      item1 = Assembly.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item1.errors.count.should == 0
      item1.destroy
      item1.errors.count.should == 0
      item1.deactivated.should be_true
      lambda{Assembly.find(item1.id)}.should raise_error(ActiveRecord::RecordNotFound)
    end
    it 'should not be able to destroy an active record' do
      num_items = Assembly.count
      attribs = FactoryGirl.attributes_for(:assembly_create)
      item1 = Assembly.create(attribs)
      item1.deactivated.should be_false
      item1.errors.count.should == 0
      item1.destroy
      item1.errors.count.should > 0
      item1.deactivated.should be_false
      item_found = Assembly.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_false 
    end
  end
end
