class CreateAssemblies < ActiveRecord::Migration
  def change
    create_table :assemblies do |t|
      t.string :description
      t.integer :sort_order
      t.boolean :required
      t.boolean :deactivated

      t.timestamps
    end
  end
end
