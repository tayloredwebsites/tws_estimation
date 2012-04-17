class CreateAssemblyComponents < ActiveRecord::Migration
  def change
    create_table :assembly_components do |t|
      t.integer :assembly_id, :null => false
      t.integer :component_id, :null => false
      t.string :description, :default => '', :null => false
      t.boolean :required, :default => true, :null => false
      t.boolean :deactivated, :default => false, :null => false

      t.timestamps
    end
    add_foreign_key(:assembly_components, :assemblies)
    add_foreign_key(:assembly_components, :components)
  end
end
