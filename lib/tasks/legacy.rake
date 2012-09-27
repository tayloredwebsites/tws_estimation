# lib/tasks/legacy.rake

namespace :legacy do

  namespace :convert do

    desc 'import all legacy data'
    task :all => [:setups, :defaults, :component_types, :components, :assemblies, :assembly_components ]

    task :setups => :environment

    desc 'import defaults table from legacy data'
    task :defaults => :setups do
      #ActiveRecord::Base.record_timestamps = false # turn off timestamps
      include Legacy::LegacyClasses
      # loop through the legacy default records
      LegacyDefaults.all.each do |old_default|
        begin
          new_default = Default.new
          new_default.attributes = {
            :store => 'Installation Rates',
            :name => old_default.name,
            :value => old_default.value
          }
          new_default.save!
          puts "Successfully migrated Defaults table."
        rescue Exception => e
          puts "Error migrating Default record #{old_default.id.to_s}, #{e.inspect.to_s}."
        end
      end
      #ActiveRecord::Base.record_timestamps = true # turn timestamps back on
    end
    
    desc 'import component_types table from legacy data'
    task :component_types => :setups do
      #ActiveRecord::Base.record_timestamps = false # turn off timestamps
      include Legacy::LegacyClasses
      # loop through the legacy component_types records
      LegacyComponentType.all.each do |old_component_type|
        begin
          new_component_type = ComponentType.new
          new_component_type.attributes = {
            :description => old_component_type.description,
            :sort_order => old_component_type.sort_order,
            :has_costs => old_component_type.has_costs,
            :has_hours => old_component_type.has_hours,
            :has_vendor => old_component_type.has_vendor,
            :has_totals => old_component_type.has_misc,
            :in_totals_grid => old_component_type.no_entry,
            :deactivated => old_component_type.deactivated
          }
          new_component_type.save!
          puts "Successfully migrated component_types table."
        rescue Exception => e
          puts "Error migrating component_types record #{old_component_type.id.to_s}, #{e.inspect.to_s}."
        end
      end
      #ActiveRecord::Base.record_timestamps = true # turn timestamps back on
    end
    
    desc 'import components table from legacy data'
    task :components => :setups do
      # untested.  recreated code
      #ActiveRecord::Base.record_timestamps = false # turn off timestamps
      include Legacy::LegacyClasses
      # loop through the legacy records
      LegacyComponent.all.each do |old_component|
        begin
          # unique component_type found by description
          old_component_type = LegacyComponentType.find(old_component.component_type_id)
          new_component_type = ComponentType.find_by_description(old_component_type.description)
          new_component = Component.new
          new_component.attributes = {
            :component_type_id => new_component_type.id,
            :description => old_component.description,
            :default_id => old_component.default_id,  # note this assumes that the default ID values have been retained !!
            :editable => old_component.calc_only,
            :deactivated => old_component.deactivated
          }
          new_component.save!
          puts "Successfully migrated Components table."
        rescue Exception => e
          puts "Error migrating Components record #{old_component.id.to_s}, #{e.inspect.to_s}."
        end
      end
      #ActiveRecord::Base.record_timestamps = true # turn timestamps back on
    end
    
    desc 'import assemblies table from legacy data'
    task :assemblies => :setups do
      #ActiveRecord::Base.record_timestamps = false # turn off timestamps
      include Legacy::LegacyClasses
      # loop through the legacy records
      LegacyAssembly.all.each do |old_table|
        begin
          new_table = Assembly.new
          new_table.attributes = {
            :description => old_table.description,
            :sort_order => old_table.sort_order,
            :required => old_table.required,
            :deactivated => old_table.deactivated
          }
          new_table.save!
          puts "Successfully migrated Assemblies table."
        rescue Exception => e
          puts "Error migrating Assemblies record #{old_table.id.to_s}, #{e.inspect.to_s}."
        end
      end
      #ActiveRecord::Base.record_timestamps = true # turn timestamps back on
    end
    
    desc 'import assembly_components table from legacy data'
    task :assembly_components => :setups do
      #ActiveRecord::Base.record_timestamps = false # turn off timestamps
      include Legacy::LegacyClasses
      # loop through the legacy records
      LegacyAssemblyComponent.all.each do |old_table|
        # unique component found by component_type and description
        old_component = LegacyComponent.find(old_table.component_id)
        # unique component_type found by description
        old_component_type = LegacyComponentType.find(old_component.component_type_id)
        new_component_type = ComponentType.scoped_by_description(old_component_type.description).first
        new_component = Component.where(:component_type_id => new_component_type.id, :description => old_component.description).first
        # unique assembly found by description
        old_assembly = LegacyAssembly.find(old_table.assembly_id)
        new_assembly = Assembly.scoped_by_description(old_assembly.description).first
        begin
          new_table = AssemblyComponent.new
          Rails.logger.debug("M migrating assembly_components AssemblyComponent component_id = #{new_component.id.to_s}, assembly_id = #{new_assembly.id.to_s}")
          new_table.attributes = {
            :component_id => new_component.id,
            :assembly_id => new_assembly.id,
            :description => (old_table.description.nil?) ? '' : old_table.description,
            :required => old_table.required,
            :deactivated => old_table.deactivated
          }
          new_table.save!
          puts "Successfully migrated assembly_components record."
        rescue Exception => e
          Rails.logger.debug("M Error migrating assembly_components record #{old_table.id.to_s},  #{e.inspect.to_s}")
        end
      end
      #ActiveRecord::Base.record_timestamps = true # turn timestamps back on
    end
    
    task :job_types => :setups do
      #ActiveRecord::Base.record_timestamps = false # turn off timestamps
      include Legacy::LegacyClasses
      # loop through the legacy default records
      LegacyJobType.all.each do |old_table|
        begin
          new_table = JobType.new
          new_table.attributes = {
            :name => old_table.name,
            :description => old_table.description,
            :sort_order => old_table.sort_order,
            :deactivated => old_table.deactivated
          }
          new_table.save!
          puts "Successfully migrated job_types table."
        rescue Exception => e
          Rails.logger.debug("M Error migrating job_types record #{old_table.id.to_s},  #{e.inspect.to_s}")
        end
      end
      #ActiveRecord::Base.record_timestamps = true # turn timestamps back on
    end
    
    
  end    # end :convert namespace
  
end
