class AddLaborRateAmountToEstimateComponents < ActiveRecord::Migration
  def change
    add_column :estimate_components, :labor_value, :decimal, :precision => 19, :scale => 2, :null => true, :default => nil
  end
end
