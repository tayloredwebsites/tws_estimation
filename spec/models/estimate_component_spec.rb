require 'spec_helper'

describe EstimateComponent do
  context 'it should have crud actions available and working' do
    it "should raise an error create user with no attributes" do
      num_items = EstimateComponent.count
      lambda {EstimateComponent.create!()}.should raise_error(ActiveRecord::RecordInvalid)
      EstimateComponent.count.should == num_items
    end    
    it "should not create user when created with no attributes" do
      num_items = EstimateComponent.count
      item = EstimateComponent.create()
      EstimateComponent.count.should == num_items
    end
    it 'should have accessible attributes match the accessible attributes for the model' do
      attribs = FactoryGirl.build(:estimate_component)._accessible_attributes
      Rails.logger.debug("T estimate_create.attributes: #{attribs.inspect.to_s}")
      # Rails.logger.debug("T attribs[:default]: #{ attribs[:default].inspect.to_s}")
      attribs_whitelist = attribs[:default]
      Rails.logger.debug("T attribs_whitelist: #{attribs_whitelist.inspect.to_s}")
      acc_attribs = generate_estimate_component_accessible_attributes()
      Rails.logger.debug("T generate_estimate_component_accessible_attributes: #{acc_attribs.inspect.to_s}")
      attribs_whitelist.size.should >= acc_attribs.size # accounting for blank entry in whitelist
      attribs_whitelist.each do |key|
        Rails.logger.debug ("T Accessible attribute #{key.to_s} = #{acc_attribs[key.to_sym].inspect.to_s}")
        acc_attribs[key.to_sym].should_not be_nil if !key.blank?
      end
    end
    it 'should create EstimateComponent when created with the minimum_attributes' do
      num_items = EstimateComponent.count
      attribs = generate_estimate_component_accessible_attributes()
      Rails.logger.debug("T generate_estimate_component_accessible_attributes: #{attribs.inspect.to_s}")
      item1 = EstimateComponent.create(attribs)
      item1.should be_instance_of(EstimateComponent)
      # loop through all of the attributes used to create this item to see if in created item
      attribs.each do | key, val |
        Rails.logger.debug("T estimate_type_spec estimate_types_min item1.send(#{key}):#{item1.send(key)}")
        item1.send(key).should == val
      end
      item1.id.should_not be_nil
      item1.errors.count.should == 0
      EstimateComponent.count.should == num_items + 1
    end   
    it 'should not create estimate_types when created missing one of the minimum_attributes' do
      num_items = EstimateComponent.count
      attribs = generate_estimate_component_min_attributes()
      attribs.each do | atrkey, atrval |
        Rails.logger.debug("T estimate_type_spec estimate_types_min - try to create item without key:#{atrkey}")
        attribs_missing = attribs.reject{|itekey, iteval| itekey == atrkey}
        item1 = EstimateComponent.create(attribs_missing)  # remove attrib key from this item create
        item1.should be_instance_of(EstimateComponent)
        # if we care what values are placed in an error object --
        # loop through all of the attributes used to create this item to see if in created item
        attribs_missing.each do | key, val |
          Rails.logger.debug("T estimate_type_spec estimate_types_min item1.send(#{key}):#{item1.send(key)}")
          item1.send(key).should == val
        end
        # item1.send(atrkey).should == nil
        item1.id.should be_nil
        item1.errors.count.should > 0
        EstimateComponent.count.should == num_items
      end
    end   
  end
  context 'it should be associated with estimates and components' do
    before (:each) do
      @estimate = Estimate.create!(generate_estimate_accessible_attributes)
      @assembly = FactoryGirl.create(:assembly_create)
      component_type = ComponentType.create!(FactoryGirl.attributes_for(:component_type))
      @component = FactoryGirl.create(:component_create, component_type: component_type)
    end
    it 'should not allow destroy of Estimate if there are estimate_components' do
      FactoryGirl.create(:estimate_component, estimate: @estimate, assembly: @assembly, component: @component)
      num_parent = Estimate.count
      @estimate.deactivate()
      @estimate.destroy()
      @estimate.errors.count.should > 0
      Estimate.count.should == num_parent
    end
    it 'should allow destroy of Estimate if there are estimate_components' do
      num_parent = Estimate.count
      @estimate.deactivate()
      @estimate.destroy()
      @estimate.errors.count.should == 0
      Estimate.count.should == num_parent - 1
    end
    it 'should not allow destroy of Assembly if there are estimate_components' do
      FactoryGirl.create(:estimate_component, estimate: @estimate, assembly: @assembly, component: @component)
      num_parent = Assembly.count
      @assembly.deactivate()
      @assembly.destroy()
      @assembly.errors.count.should > 0
      Assembly.count.should == num_parent
    end
    it 'should allow destroy of Assembly if there are estimate_components' do
      num_parent = Assembly.count
      @assembly.deactivate()
      @assembly.destroy()
      @assembly.errors.count.should == 0
      Assembly.count.should == num_parent - 1
    end
    it 'should not allow destroy of Component if there are estimate_components' do
      FactoryGirl.create(:estimate_component, estimate: @estimate, assembly: @assembly, component: @component)
      num_parent = Component.count
      @component.deactivate()
      @component.destroy()
      @component.errors.count.should > 0
      Component.count.should == num_parent
    end
    it 'should allow destroy of Component if there are estimate_components' do
      num_parent = Component.count
      @component.deactivate()
      @component.destroy()
      @component.errors.count.should == 0
      Component.count.should == num_parent - 1
    end
  end

end
