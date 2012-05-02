class CreateEstimates < ActiveRecord::Migration
  def change
    create_table :estimates do |t|
      t.string :title, :null => false
      t.string :customer_name, :null => false
      t.string :customer_note, :default => '', :null => false
      t.references :sales_rep, :null => false
      t.references :job_type, :null => false
      t.references :state, :null => false
      t.boolean :prevailing_wage, :default => false, :null => false
      t.string :note, :default => '', :null => false
      t.boolean :deactivated, :default => false, :null => false

      t.timestamps
    end
    add_index :estimates, :sales_rep_id
    add_index :estimates, :job_type_id
    add_index :estimates, :state_id
  end
end
