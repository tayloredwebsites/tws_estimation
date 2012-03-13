class CreateComponentTypes < ActiveRecord::Migration
  def change
    create_table :component_types do |t|
      t.string :description, :default => '', :null => false
      t.integer :sort_order, :default => 0, :null => false
      t.boolean :has_costs, :default => true, :null => false
      t.boolean :has_hours, :default => false, :null => false
      t.boolean :has_vendor, :default => false, :null => false
      t.boolean :has_misc, :default => false, :null => false
      t.boolean :no_entry, :default => false, :null => false
      t.boolean :deactivated, :default => false, :null => false
      t.timestamps
    end
    add_index(:component_types, :description, :unique => true)
  end
end
