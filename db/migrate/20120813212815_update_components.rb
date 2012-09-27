class UpdateComponents < ActiveRecord::Migration
  def up
    rename_column :components, :calc_only, :editable
    add_column :components, :operation, :string
    add_column :components, :subtotal_group, :string
  end

  def down
    rename_column :components, :editable, :calc_only
    remove_column :components, :operation, :string
    remove_column :components, :subtotal_group, :string
  end
end
