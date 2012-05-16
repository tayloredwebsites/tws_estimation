class EstimateAssemblyDeactivatedToSelected < ActiveRecord::Migration
  def up
    rename_column :estimate_assemblies, :deactivated, :selected
  end

  def down
    rename_column :estimate_assemblies, :selected, :deactivated
  end
end
