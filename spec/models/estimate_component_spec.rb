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
      attribs_whitelist.size.should == acc_attribs.size
      attribs_whitelist.each do |key, val|
        Rails.logger.debug ("T Accessible attribute #{key.to_s} = #{acc_attribs[key.to_sym].inspect.to_s}")
        acc_attribs[key.to_sym].should_not be_nil
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

  context "Estimate update attributes passed to EstimateComponent - " do
    before (:each) do
      @attribs = generate_estimate_accessible_attributes
      @assembly = Assembly.create!(FactoryGirl.attributes_for(:assembly_create))
      component_type1 = ComponentType.create!(FactoryGirl.attributes_for(:component_type))
      @component1 = FactoryGirl.create(:component_create, component_type: component_type1)
      @component2 = FactoryGirl.create(:component_create, component_type: component_type1)
    end
    it "Estimate.create should call the update_estimate_component_attributes of Estimate" # do
    #   Rails.logger.debug("T attribs = #{@attribs.inspect.to_s}")
    #   estimate = Estimate.new(@attribs)
    #   a_attribs1 = {:estimate_id=>"0", :assembly_id=>"#{@assembly.id.to_s}", :selected => true}
    #   Rails.logger.debug("T a_attribs1 = #{a_attribs1.inspect.to_s}")
    #   estimate.estimate_assemblies.build(a_attribs1)
    #   # c_attribs = EstimateComponent.params_from_key_string("#{estimate.id}_#{@assembly.id}_#{@component1.id}_0").merge(:value => "123.48")
    #   c_attribs = EstimateComponent.params_from_key_string("0_#{@assembly.id}_#{@component1.id}_0").merge(:value => "123.48")
    #   Rails.logger.debug("T c_attribs = #{c_attribs.inspect.to_s}")
    #   estimate.estimate_components.build(c_attribs)
    #   Rails.logger.debug("T estimate.estimate_components = #{estimate.estimate_components.inspect.to_s}")
    #   estimate.save!
    #   # estimate.update_attributes(@attribs)
    #   item1_updated = Estimate.find(estimate.id)
    #   Rails.logger.debug("T item1_updated = #{item1_updated.inspect.to_s}")
    #   Rails.logger.debug("T item1_updated.estimate_components = #{item1_updated.estimate_components.inspect.to_s}")
    #   # item1_updated.estimate_components.first.assembly_id.should == @assembly.id
    #   item1_updated.estimate_components.first.component_id.should == @component1.id
    # end
    it "Estimate.update_attributes should call the update_estimate_component_attributes of Estimate" do
      Rails.logger.debug("T attribs = #{@attribs.inspect.to_s}")
      estimate = Estimate.create!(@attribs)
      est_comp = EstimateComponent.new()
      # est_comp.estimate_id = est_comp_ids[0]
      est_comp.estimate_id = estimate.id
      est_comp.assembly_id = @assembly.id
      est_comp.component_id = @component2.id
      est_comp.value = BigDecimal(123.48,2)
      est_comp.save!
      item1_updated = Estimate.find(estimate.id)
      Rails.logger.debug("T item1_updated = #{item1_updated.inspect.to_s}")
      Rails.logger.debug("T item1_updated.estimate_components = #{item1_updated.estimate_components.inspect.to_s}")
      # item1_updated.estimate_components.first.assembly_id.should == @assembly.id
      item1_updated.estimate_components.first.component_id.should == @component2.id
    end
  end

  context 'misc - ' do
    it 'should have estimate calculations performed'
  end

end
