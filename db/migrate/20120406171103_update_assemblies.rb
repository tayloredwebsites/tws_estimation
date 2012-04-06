class UpdateAssemblies < ActiveRecord::Migration
  def up
    change_column(:assemblies, :description, :string, :default => '', :null => false)
    change_column(:assemblies, :sort_order, :integer, :default => 0, :null => false)
    change_column(:assemblies, :required, :boolean, :default => false, :null => false)
    change_column(:assemblies, :deactivated, :boolean, :default => false, :null => false)
    add_index(:assemblies, :description, :unique => true)
  end

  def down
  end
end
