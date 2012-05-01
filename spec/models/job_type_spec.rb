require 'spec_helper'

describe JobType do
  context 'it should have crud actions available and working' do
    it "should raise an error create user with no attributes" do
      num_items = JobType.count
      lambda {JobType.create!()}.should raise_error(ActiveRecord::RecordInvalid)
      JobType.count.should == num_items
    end    
    it "should not create user when created with no attributes" do
      num_items = JobType.count
      item = JobType.create()
      JobType.count.should == num_items
    end    
    it 'should create user when created with the minimum_attributes' do
      num_items = JobType.count
      attribs = FactoryGirl.attributes_for(:job_type_min)
      item1 = JobType.create(attribs)
      item1.should be_instance_of(JobType)
      # loop through all of the attributes used to create this item to see if in created item
      attribs.each do | key, val |
        Rails.logger.debug("T job_type_spec job_types_min item1.send(#{key}):#{item1.send(key)}")
        item1.send(key).should == val
      end
      item1.id.should_not be_nil
      item1.errors.count.should == 0
      JobType.count.should == num_items + 1
    end   
    it 'should not create job_types when created missing one of the minimum_attributes' do
      num_items = JobType.count
      attribs = FactoryGirl.attributes_for(:job_type_min)
      attribs.each do | atrkey, atrval |
        Rails.logger.debug("T job_type_spec job_types_min - try to create item without key:#{atrkey}")
        attribs_missing = attribs.reject{|itekey, iteval| itekey == atrkey}
        item1 = JobType.create(attribs_missing)  # remove attrib key from this item create
        item1.should be_instance_of(JobType)
        # if we care what values are placed in an error object --
        # loop through all of the attributes used to create this item to see if in created item
        attribs_missing.each do | key, val |
          Rails.logger.debug("T job_type_spec job_types_min item1.send(#{key}):#{item1.send(key)}")
          item1.send(key).should == val
        end
        item1.send(atrkey).should == ''
        item1.id.should be_nil
        item1.errors.count.should > 0
        JobType.count.should == num_items
      end
      
    end   
  end
  context 'it should have deactivated actions available and working' do
    it 'should be able to deactivate an active record' do
      num_items = JobType.count
      attribs = FactoryGirl.attributes_for(:job_type)
      item1 = JobType.create(attribs)
      item1.deactivated.should be_false
      JobType.count.should == num_items + 1
      item1.deactivate
      item1.deactivated.should be_true
      item_found = JobType.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true     
    end
    it 'should not be able to deactivate a deactivated record' do
      num_items = JobType.count
      attribs = FactoryGirl.attributes_for(:job_type)
      item1 = JobType.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item_found = JobType.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true 
      item_found.errors.count.should == 0
      item_found.deactivate
      item_found.errors.count.should > 0
      item_found2 = JobType.find(item_found.id)
      item_found2.should_not be_nil
      item_found2.deactivated.should be_true 
    end
    it 'should be able to reactivate a deactivated record' do
      num_items = JobType.count
      attribs = FactoryGirl.attributes_for(:job_type)
      item1 = JobType.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item_found = JobType.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true 
      item_found.errors.count.should == 0
      item_found.reactivate
      item_found.errors.count.should == 0
      item_found2 = JobType.find(item_found.id)
      item_found2.should_not be_nil
      item_found2.deactivated.should be_false
    end
    it 'should not be able to reactivate an active record' do
      num_items = JobType.count
      attribs = FactoryGirl.attributes_for(:job_type)
      item1 = JobType.create(attribs)
      item1.deactivated.should be_false
      item1.errors.count.should == 0
      item1.reactivate
      item1.errors.count.should > 0
      item1.deactivated.should be_false
      item_found = JobType.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_false 
    end
    it 'should be able to destroy a deactivated record' do
      num_items = JobType.count
      attribs = FactoryGirl.attributes_for(:job_type)
      item1 = JobType.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item1.errors.count.should == 0
      item1.destroy
      item1.errors.count.should == 0
      item1.deactivated.should be_true
      lambda{JobType.find(item1.id)}.should raise_error(ActiveRecord::RecordNotFound)
    end
    it 'should not be able to destroy an active record' do
      num_items = JobType.count
      attribs = FactoryGirl.attributes_for(:job_type)
      item1 = JobType.create(attribs)
      item1.deactivated.should be_false
      item1.errors.count.should == 0
      item1.destroy
      item1.errors.count.should > 0
      item1.deactivated.should be_false
      item_found = JobType.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_false 
    end
  end
end
