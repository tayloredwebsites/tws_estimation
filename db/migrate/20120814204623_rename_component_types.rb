class RenameComponentTypes < ActiveRecord::Migration
  def up
    rename_column :component_types, :no_entry, :in_totals_grid
  end

  def down
    rename_column :component_types, :in_totals_grid, :no_entry
  end
end
