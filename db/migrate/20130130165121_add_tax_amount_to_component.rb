class AddTaxAmountToComponent < ActiveRecord::Migration
  def up
    add_column :estimate_components, :tax_percent, :decimal, :precision => 19, :scale => 4,:null => true, :default => nil
    add_column :estimate_components, :tax_amount, :decimal, :precision => 19, :scale => 2,:null => true, :default => nil
  end
  def down
    remove_column :estimate_components, :tax_percent
    remove_column :estimate_components, :tax_amount
  end
end
