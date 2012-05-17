class EstimateAssembliesForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key(:estimate_assemblies, :estimates)
    add_foreign_key(:estimate_assemblies, :assemblies)
  end
end
