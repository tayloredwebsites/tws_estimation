require 'spec_helper'

describe Estimate do
  context 'it should have crud actions available and working' do
    it "should raise an error create user with no attributes" do
      num_items = Estimate.count
      lambda {Estimate.create!()}.should raise_error(ActiveRecord::RecordInvalid)
      Estimate.count.should == num_items
    end    
    it "should not create user when created with no attributes" do
      num_items = Estimate.count
      item = Estimate.create()
      Estimate.count.should == num_items
    end    
    it 'should create user when created with the minimum_attributes' do
      num_items = Estimate.count
      attribs = generate_estimate_accessible_attributes
      Rails.logger.debug("T estimate_spec estimates_min attribs = #{attribs.inspect.to_s}")
      item1 = Estimate.create(attribs)
      Rails.logger.debug("T estimate_spec estimates_min item1 = #{item1.inspect.to_s}")
      item1.should be_instance_of(Estimate)
      # loop through all of the attributes used to create this item to see if in created item
      attribs.each do | key, val |
        Rails.logger.debug("T estimate_spec estimates_min item1.send(#{key}):#{item1.send(key)}")
        item1.send(key).should == val
      end
      item1.id.should_not be_nil
      item1.errors.count.should == 0
      Estimate.count.should == num_items + 1
    end   
    it 'should not create estimates when created missing one of the minimum_attributes' do
      num_items = Estimate.count
      attribs = generate_estimate_min_attributes
      Rails.logger.debug("T estimate_spec estimates_min - attribs = #{attribs.inspect.to_s}")
      attribs.each do | atrkey, atrval |
        Rails.logger.debug("T estimate_spec estimates_min - try to create item without key:#{atrkey}")
        attribs_missing = attribs.reject{|itekey, iteval| itekey == atrkey}
        item1 = Estimate.create(attribs_missing)  # remove attrib key from this item create
        item1.should be_instance_of(Estimate)
        # if we care what values are placed in an error object --
        # loop through all of the attributes used to create this item to see if in created item
        attribs_missing.each do | key, val |
          Rails.logger.debug("T estimate_spec estimates_min item1.send(#{key}):#{item1.send(key)}")
          item1.send(key).should == val
        end
        item1.send(atrkey).nil_to_s.should == ''
        item1.id.should be_nil
        item1.errors.count.should > 0
        Estimate.count.should == num_items
      end
      
    end   
  end
  context 'it should have deactivated actions available and working' do
    it 'should be able to deactivate an active record' do
      num_items = Estimate.count
      attribs = generate_estimate_accessible_attributes
      item1 = Estimate.create(attribs)
      item1.deactivated.should be_false
      Estimate.count.should == num_items + 1
      item1.deactivate
      item1.deactivated.should be_true
      item_found = Estimate.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true     
    end
    it 'should not be able to deactivate a deactivated record' do
      num_items = Estimate.count
      attribs = generate_estimate_accessible_attributes
      item1 = Estimate.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item_found = Estimate.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true 
      item_found.errors.count.should == 0
      item_found.deactivate
      item_found.errors.count.should > 0
      item_found2 = Estimate.find(item_found.id)
      item_found2.should_not be_nil
      item_found2.deactivated.should be_true 
    end
    it 'should be able to reactivate a deactivated record' do
      num_items = Estimate.count
      attribs = generate_estimate_accessible_attributes
      item1 = Estimate.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item_found = Estimate.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true 
      item_found.errors.count.should == 0
      item_found.reactivate
      item_found.errors.count.should == 0
      item_found2 = Estimate.find(item_found.id)
      item_found2.should_not be_nil
      item_found2.deactivated.should be_false
    end
    it 'should not be able to reactivate an active record' do
      num_items = Estimate.count
      attribs = generate_estimate_accessible_attributes
      item1 = Estimate.create(attribs)
      item1.deactivated.should be_false
      item1.errors.count.should == 0
      item1.reactivate
      item1.errors.count.should > 0
      item1.deactivated.should be_false
      item_found = Estimate.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_false 
    end
    it 'should be able to destroy a deactivated record' do
      num_items = Estimate.count
      attribs = generate_estimate_accessible_attributes
      item1 = Estimate.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item1.errors.count.should == 0
      item1.destroy
      item1.errors.count.should == 0
      item1.deactivated.should be_true
      lambda{Estimate.find(item1.id)}.should raise_error(ActiveRecord::RecordNotFound)
    end
    it 'should not be able to destroy an active record' do
      num_items = Estimate.count
      attribs = generate_estimate_accessible_attributes
      item1 = Estimate.create(attribs)
      item1.deactivated.should be_false
      item1.errors.count.should == 0
      item1.destroy
      item1.errors.count.should > 0
      item1.deactivated.should be_false
      item_found = Estimate.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_false 
    end
  end
end
