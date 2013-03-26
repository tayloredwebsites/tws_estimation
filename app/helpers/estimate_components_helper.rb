module EstimateComponentsHelper
  def edit_hourly_rate_tags(estimate, assembly, assembly_component, estimate_component)
    content_tag :span, :class => 'hourly_rate_calculations' do
      concat content_tag(:span, label_tag("estimate_components_labor_rate[#{assembly.id.to_s}_#{assembly_component.component.id.to_s}]", '@' ))
      concat content_tag(:span, text_field_tag("estimate_components_labor_rate[#{assembly.id.to_s}_#{assembly_component.component.id.to_s}]", estimate_component.labor_rate_for(assembly_component.component).bd_to_s(2)))
      concat content_tag(:span, ' /hr => $ '+ "#{estimate_component.labor_rate_value.bd_to_s(2)}", :id => "estimate_components_labor_value_#{assembly.id.to_s}_#{assembly_component.component.id.to_s}")
    end
  end
  def show_hourly_rate_tags(estimate, assembly, assembly_component, estimate_component)
    content_tag :span, :class => 'hourly_rate_calculations' do
      # note concat on the nested content tags does not work - must use the expression tag
      concat content_tag(:span, label_tag("estimate_components_labor_rate_[#{assembly.id.to_s}_#{assembly_component.component.id.to_s}]", '@' ))
      concat content_tag(:span, estimate_component.labor_rate_for(assembly_component.component).bd_to_s(2), :id => "estimate_components_labor_rate_#{assembly.id.to_s}_#{assembly_component.component.id.to_s}")
      concat content_tag(:span, ' /hr => $ '+ "#{estimate_component.labor_value.bd_to_s(2)}", :id => "estimate_components_labor_value_#{assembly.id.to_s}_#{assembly_component.component.id.to_s}")
    end
  end
  def edit_tax_calculation_tags(estimate, assembly, assembly_component, estimate_component)
    content_tag :span, :class => 'estimate_tax_calculations' do
        # note concat on the nested content tags does not work - must use the expression tag
        concat content_tag(:span, label_tag("estimate_components_tax_pct[#{assembly.id.to_s}_#{assembly_component.component.id.to_s}]", 'tax %' ))
        concat content_tag(:span, text_field_tag("estimate_components_tax_pct[#{assembly.id.to_s}_#{assembly_component.component.id.to_s}]", estimate_component.tax_percent_for(estimate, assembly_component.component).bd_to_s(3)))
        concat content_tag(:span, ' => $ '+ "#{estimate_component.tax_amount.bd_to_s(2)}", :id => "estimate_components_tax_amt_#{assembly.id.to_s}_#{assembly_component.component.id.to_s}")
    end
  end
  def show_tax_calculations_tags(estimate, assembly, assembly_component, estimate_component)
    content_tag :span, :class => 'estimate_tax_calculations' do
        # note concat on the nested content tags does not work - must use the expression tag
        concat content_tag(:span, label_tag("estimate_components_tax_pct[#{assembly.id.to_s}_#{assembly_component.component.id.to_s}]", 'tax %' ))
        concat content_tag(:span, estimate_component.tax_percent.bd_to_s(3), :id => "estimate_components_tax_pct_#{assembly.id.to_s}_#{assembly_component.component.id.to_s}")
        concat content_tag(:span, ' => $ '+ "#{estimate_component.tax_amount.bd_to_s(2)}", :id => "estimate_components_tax_amt_#{assembly.id.to_s}_#{assembly_component.component.id.to_s}")
    end
  end
  
  def show_hidden_fields(estimate, assembly, assembly_component, estimate_component, estimate_component_was)
    estimate_component_was_note = estimate_component_was.nil? ? '' : estimate_component_was.note
    content_tag :span, :class => 'component_hidden_fields' do
      # note concat on the nested content tags does not work - must use the expression tag
      concat hidden_field_tag("estimate_components_was[#{assembly.id.to_s}_#{assembly_component.component.id.to_s}]",  estimate_component_was_note)
      concat hidden_field_tag("estimate_components_tax_pct_was[#{assembly.id.to_s}_#{assembly_component.component.id.to_s}]", estimate_component.tax_percent_for(estimate, assembly_component.component).bd_to_s(3))
      concat hidden_field_tag("estimate_components_note_was[#{assembly.id.to_s}_#{assembly_component.component.id.to_s}]", estimate_component.note)
    end
  end



end
