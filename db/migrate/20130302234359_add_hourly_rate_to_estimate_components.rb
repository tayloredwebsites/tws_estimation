class AddHourlyRateToEstimateComponents < ActiveRecord::Migration
  def up
    add_column :estimate_components, :labor_rate_value, :decimal, :precision => 19, :scale => 2, :null => true, :default => nil
  end

  def down
    remove_column :estimate_components, :labor_rate_value
  end
end
