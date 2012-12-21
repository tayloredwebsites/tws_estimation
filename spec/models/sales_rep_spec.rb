require 'spec_helper'

describe SalesRep do
  context 'it should have crud actions available and working' do
    it "should raise an error create user with no attributes" do
      num_items = SalesRep.count
      lambda {SalesRep.create!()}.should raise_error(ActiveRecord::RecordInvalid)
      SalesRep.count.should == num_items
    end
    it "should not create user when created with no attributes" do
      num_items = SalesRep.count
      item = SalesRep.create()
      SalesRep.count.should == num_items
    end
    it 'should have tests accessible attributes match the accessible attributes for the model' do
      attribs = FactoryGirl.build(:sales_rep_create)._accessible_attributes
      # Rails.logger.debug("T sales_rep_create.attributes: #{attribs.inspect.to_s}")
      # Rails.logger.debug("T attribs[:default]: #{ attribs[:default].inspect.to_s}")
      attribs_whitelist = attribs[:default]
      # Rails.logger.debug("T attribs_whitelist: #{attribs_whitelist.inspect.to_s}")
      acc_attribs = generate_sales_rep_accessible_attributes()
      # Rails.logger.debug("T generate_sales_rep_accessible_attributes: #{acc_attribs.inspect.to_s}")
      attribs_whitelist.size.should >= acc_attribs.size # accounting for blank entry in whitelist
      attribs_whitelist.each do |key|
        Rails.logger.debug ("T Accessible attribute #{key.to_s} = #{acc_attribs[key.to_sym].inspect.to_s}")
        acc_attribs[key.to_sym].should_not be_nil if !key.blank?
      end
    end
    it 'should create user when created with the minimum_attributes' do
      num_items = SalesRep.count
      attribs = generate_sales_rep_accessible_attributes()
      Rails.logger.debug("T generate_sales_rep_accessible_attributes: #{attribs.inspect.to_s}")
      item1 = SalesRep.create(attribs)
      item1.should be_instance_of(SalesRep)
      # loop through all of the attributes used to create this item to see if in created item
      attribs.each do | key, val |
        Rails.logger.debug("T user_spec users_min item1.send(#{key}):#{item1.send(key)}")
        item1.send(key).should == val
      end
      item1.id.should_not be_nil
      item1.errors.count.should == 0
      SalesRep.count.should == num_items + 1
    end
    it 'should not create users when created missing one of the minimum_attributes' do
      num_items = SalesRep.count
      attribs = generate_sales_rep_min_attributes()
      attribs.each do | atrkey, atrval |
        Rails.logger.debug("T user_spec users_min - try to create item without key:#{atrkey}")
        attribs_missing = attribs.reject{|itekey, iteval| itekey == atrkey}
        item1 = SalesRep.create(attribs_missing)  # remove attrib key from this item create
        item1.should be_instance_of(SalesRep)
        # if we care what values are placed in an error object --
        # loop through all of the attributes used to create this item to see if in created item
        attribs_missing.each do | key, val |
          Rails.logger.debug("T user_spec users_min item1.send(#{key}):#{item1.send(key)}")
          item1.send(key).should == val
        end
        # item1.send(atrkey).should == nil
        item1.id.should be_nil
        item1.errors.count.should > 0
        SalesRep.count.should == num_items
      end
    end
  end
  context 'it should have deactivated actions available and working' do
    it 'should be able to deactivate an active record' do
      num_items = SalesRep.count
      attribs = generate_sales_rep_accessible_attributes()
      item1 = SalesRep.create(attribs)
      item1.deactivated.should be_false
      SalesRep.count.should == num_items + 1
      item1.deactivate
      item1.deactivated.should be_true
      item_found = SalesRep.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true
    end
    it 'should not be able to deactivate a deactivated record' do
      num_items = SalesRep.count
      attribs = generate_sales_rep_accessible_attributes()
      item1 = SalesRep.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item_found = SalesRep.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true
      item_found.errors.count.should == 0
      item_found.deactivate
      item_found.errors.count.should > 0
      item_found2 = SalesRep.find(item_found.id)
      item_found2.should_not be_nil
      item_found2.deactivated.should be_true
    end
    it 'should be able to reactivate a deactivated record' do
      num_items = SalesRep.count
      attribs = generate_sales_rep_accessible_attributes()
      item1 = SalesRep.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item_found = SalesRep.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_true
      item_found.errors.count.should == 0
      item_found.reactivate
      item_found.errors.count.should == 0
      item_found2 = SalesRep.find(item_found.id)
      item_found2.should_not be_nil
      item_found2.deactivated.should be_false
    end
    it 'should not be able to reactivate an active record' do
      num_items = SalesRep.count
      attribs = generate_sales_rep_accessible_attributes()
      item1 = SalesRep.create(attribs)
      item1.deactivated.should be_false
      item1.errors.count.should == 0
      item1.reactivate
      item1.errors.count.should > 0
      item1.deactivated.should be_false
      item_found = SalesRep.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_false
    end
    it 'should be able to destroy a deactivated record' do
      num_items = SalesRep.count
      attribs = generate_sales_rep_accessible_attributes()
      item1 = SalesRep.create(attribs)
      item1.deactivated.should be_false
      item1.deactivate
      item1.deactivated.should be_true
      item1.errors.count.should == 0
      item1.destroy
      item1.errors.count.should == 0
      item1.deactivated.should be_true
      lambda{SalesRep.find(item1.id)}.should raise_error(ActiveRecord::RecordNotFound)
    end
    it 'should not be able to destroy an active record' do
      num_items = SalesRep.count
      attribs = generate_sales_rep_accessible_attributes()
      item1 = SalesRep.create(attribs)
      item1.deactivated.should be_false
      item1.errors.count.should == 0
      item1.destroy
      item1.errors.count.should > 0
      item1.deactivated.should be_false
      item_found = SalesRep.find(item1.id)
      item_found.should_not be_nil
      item_found.deactivated.should be_false
    end
  end
  context 'it should be associated with user' do
    before (:each) do
      @parent = FactoryGirl.create(:user_full_create_attr)
    end
    it 'should only allow the sales_rep to belong to one user' do
      attribs = generate_sales_rep_accessible_attributes(@parent.id)
      sales_rep1 = SalesRep.create(attribs)
      # Rails.logger.debug("T sales_rep1 = #{sales_rep1.inspect.to_s}")
      @parent.sales_rep.id.should == sales_rep1.id
      sales_rep1.user.id.should == @parent.id
      sales_rep2 = SalesRep.create(generate_sales_rep_accessible_attributes(@parent.id))
      sales_rep2.errors.count.should > 0
      sales_rep2.errors[:user_id].should == ["#{I18n.translate('activerecord.errors.messages.taken')}"]
      # Rails.logger.debug("T sales_rep2 = #{sales_rep2.inspect.to_s}")
      sales_rep2.id.should be_nil
      @parent.sales_rep.id.should == sales_rep1.id
    end
    it 'should not allow destroy of parent if there is a child' do
      attribs = generate_sales_rep_accessible_attributes(@parent.id)
      sales_rep1 = SalesRep.create(attribs)
      # Rails.logger.debug("T sales_rep1 = #{sales_rep1.inspect.to_s}")
      @parent.sales_rep.id.should == sales_rep1.id
      sales_rep1.user.id.should == @parent.id
      num_parent = SalesRep.count
      @parent.deactivate()
      @parent.destroy()
      @parent.errors.count.should > 0
      SalesRep.count.should == num_parent
    end
    it 'should allow destroy of user if there are no children' do
      num_parent = User.count
      @parent.deactivate()
      @parent.destroy()
      @parent.errors.count.should == 0
      SalesRep.count.should == num_parent - 1
    end
  end
end
