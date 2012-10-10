class ChangeComponentTypes < ActiveRecord::Migration
  def up
    rename_column :component_types, :has_misc, :has_totals
  end

  def down
    rename_column :component_types, :has_totals, :has_misc
  end
end
