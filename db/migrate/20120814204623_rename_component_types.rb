class RenameComponentTypes < ActiveRecord::Migration
  def up
    rename_column :component_types, :no_entry, :totals_grid
  end

  def down
    rename_column :component_types, :totals_grid, :no_entry
  end
end
