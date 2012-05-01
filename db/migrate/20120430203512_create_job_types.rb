class CreateJobTypes < ActiveRecord::Migration
  def change
    create_table :job_types do |t|
      t.string :name, :default => '', :null => false
      t.string :description, :default => '', :null => false
      t.integer :sort_order, :default => 0, :null => false
      t.boolean :deactivated, :default => false, :null => false

      t.timestamps
    end
  end
end
