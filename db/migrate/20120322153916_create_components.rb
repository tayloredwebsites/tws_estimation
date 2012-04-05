class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.integer :component_type_id, :null => false
      t.string :description, :default => '', :null => false
      t.integer :default_id, :null => true
      t.boolean :calc_only, :default => false, :null => false
      t.boolean :deactivated, :default => false, :null => false
      t.timestamps
    end
    add_index(:components, [:component_type_id, :description], :unique => true)
    add_foreign_key(:components, :component_types)
    add_foreign_key(:components, :defaults)
  end
end
