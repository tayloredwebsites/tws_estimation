class DifferentLaborRates < ActiveRecord::Migration
  def up
    add_column :components, :labor_rate_default_id, :integer, :null => true
    add_index :components, :labor_rate_default_id
    add_foreign_key :components, :defaults, :column => :labor_rate_default_id
  end

  def down
    remove_foreign_key :components, :column => :labor_rate_default_id
    remove_index :components, :labor_rate_default_id
    remove_column :components, :labor_rate_default_id
  end
end
