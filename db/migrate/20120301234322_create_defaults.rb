class CreateDefaults < ActiveRecord::Migration
  def change
    create_table :defaults do |t|
		t.string  "store", :null => false, :default => ''
		t.string  "name", :null => false, :default => ''
		t.decimal "value", :precision => 19, :scale => 4, :null => false, :default => 0
		t.boolean "deactivated", :null => false, :default => false
		t.timestamps
    end
  end
end
