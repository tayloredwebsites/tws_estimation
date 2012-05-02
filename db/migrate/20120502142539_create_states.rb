class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :code, :default => '', :null => false
      t.string :name, :default => '', :null => false

      t.timestamps
    end
  end
end
