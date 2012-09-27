class ChangeComponentTypes < ActiveRecord::Migration
  def up
    rename_column :component_types, :has_misc, :has_totals
    rename_column :component_types, :totals_grid, :in_totals_grid
  end

  def down
    rename_column :component_types, :has_totals, :has_misc
    rename_column :component_types, :in_totals_grid, :totals_grid
  end
end
