class AddTypesInCalcToEstimateComponents < ActiveRecord::Migration
  def change
    add_column :estimate_components, :types_in_calc, :string, :null => false, :default => ''
  end
end
