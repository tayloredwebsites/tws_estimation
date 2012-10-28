class RemoveOperationFromComponents < ActiveRecord::Migration
  def up
  	remove_column :components, :operation
  	remove_column :components, :subtotal_group
  	add_column :components, :grid_operand, :string, :null => true
  	add_column :components, :grid_scope, :string, :null => true
  	add_column :components, :grid_subtotal, :string, :null => true
  end

  def down
  	remove_column :components, :grid_operand
  	remove_column :components, :grid_scope
  	remove_column :components, :grid_subtotal
  	add_column :components, :operation, :string
  	add_column :components, :subtotal_group, :string
  end
end
