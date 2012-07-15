class UpdateEstimateComponents < ActiveRecord::Migration
  def up
    drop_table :estimate_components
    create_table :estimate_components do |t|
      t.references :estimate, :null => false
      t.references :assembly, :null => false
      t.references :component, :null => false
      t.string :write_in_name, :null => false, :default => ''
      t.decimal :value, :precision => 19, :scale => 4, :null => false, :default => 0
      t.boolean :deactivated, :default => false, :null => false
      t.timestamps
    end
    add_index :estimate_components, :estimate_id
    add_index :estimate_components, :assembly_id
    add_index :estimate_components, :component_id
    add_index :estimate_components, [:estimate_id, :assembly_id, :component_id], :unique => true, :name => 'unique_estimate_component'
    
    add_foreign_key(:estimate_components, :estimates)
    add_foreign_key(:estimate_components, :assemblies)
    add_foreign_key(:estimate_components, :components)
  end

  def down
    drop_table :estimate_components
    create_table :estimate_components do |t|
      t.references :estimate_assembly, :null => false
      t.references :assembly_component, :null => false
      t.string :write_in_name, :null => false, :default => ''
      t.decimal :value, :precision => 19, :scale => 4, :null => false, :default => 0
      t.boolean :deactivated, :default => false, :null => false
      t.timestamps
    end
    add_index :estimate_components, :estimate_assembly_id
    add_index :estimate_components, :assembly_component_id
    add_foreign_key(:estimate_components, :estimate_assemblies)
    add_foreign_key(:estimate_components, :assembly_components)
  end
end
