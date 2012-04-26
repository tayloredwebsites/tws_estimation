class CreateSalesReps < ActiveRecord::Migration
  def change
    create_table :sales_reps do |t|
      t.integer :user_id, :null => false
      t.decimal :min_markup_pct, :precision => 18, :scale => 4, :null => true
      t.decimal :max_markup_pct, :precision => 18, :scale => 4, :null => true
      t.boolean :deactivated, :default => false, :null => false

      t.timestamps
    end
    add_foreign_key(:sales_reps, :users)
  end
end
