class CreateStateComponentTypeTaxes < ActiveRecord::Migration
  def up
    create_table :state_component_type_taxes do |t|
      t.references :state, :null => false
      t.references :job_type, :null => false
      t.references :component_type, :null => false
      t.decimal :tax_percent, :precision => 19, :scale => 4
      t.boolean :deactivated, :default => false, :null => false
      t.timestamps
    end
    add_index :state_component_type_taxes, :state_id
    add_foreign_key :state_component_type_taxes, :states
    add_index :state_component_type_taxes, :job_type_id
    add_foreign_key :state_component_type_taxes, :job_types
    add_index :state_component_type_taxes, :component_type_id
    add_foreign_key :state_component_type_taxes, :component_types
  end

  def down
    remove_foreign_key :state_component_type_taxes, :states
    remove_index :state_component_type_taxes, :state_id
    remove_foreign_key :state_component_type_taxes, :job_types
    remove_index :state_component_type_taxes, :job_type_id
    remove_foreign_key :state_component_type_taxes, :component_types
    remove_index :state_component_type_taxes, :component_type_id
    drop_table :state_component_type_taxes
  end
end
