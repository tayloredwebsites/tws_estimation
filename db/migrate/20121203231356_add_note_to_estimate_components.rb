class AddNoteToEstimateComponents < ActiveRecord::Migration
  def up
    add_column :estimate_components, :note, :string, :default => '', :null => false
  end
  def down
    remove_column :estimate_components, :note
  end
end
