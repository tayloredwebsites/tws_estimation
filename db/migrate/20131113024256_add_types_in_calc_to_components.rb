class AddTypesInCalcToComponents < ActiveRecord::Migration
  def change
    add_column :components, :types_in_calc, :string, :null => false, :default => ''
  end
end
