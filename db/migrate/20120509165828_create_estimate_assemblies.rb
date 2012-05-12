class CreateEstimateAssemblies < ActiveRecord::Migration
  def change
    create_table :estimate_assemblies do |t|
      t.references :estimate, :null => false
      t.references :assembly, :null => false
      t.boolean :deactivated, :default => false, :null => false

      t.timestamps
    end
    add_index :estimate_assemblies, :estimate_id
    add_index :estimate_assemblies, :assembly_id
  end
end
