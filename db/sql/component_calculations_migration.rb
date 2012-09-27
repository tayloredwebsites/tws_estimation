# class CreateComponentCalculations < ActiveRecord::Migration
#   def change
#     create_table :component_calculations do |t|
#       t.references :component, :null => false
#       t.references :component_type, :null => false
#       t.references :default, :null => false
#       t.boolean :editable, :null => false, :default => true
#       t.string :operation, :null => false, :default => ''
#       t.boolean :deactivated, :default => false, :null => false
#       t.timestamps
#     end
#     add_index :component_calculations, :component_id
#     add_index :component_calculations, :component_type_id
#     add_index :component_calculations, :default_id
#     add_index :component_calculations, [:component_id, :component_type_id], :unique => true, :name => 'unique_component_calculation'
#     
#     add_foreign_key(:component_calculations, :components)
#     add_foreign_key(:component_calculations, :component_types)
#     add_foreign_key(:component_calculations, :defaults)
#   end
# end
