class EstimatesForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key(:estimates, :sales_reps)
    add_foreign_key(:estimates, :job_types)
    add_foreign_key(:estimates, :states)
  end
end
