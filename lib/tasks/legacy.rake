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
            :name => old_default.co_name,
            :value => old_default.co_value
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
            :description => old_component_type.comp_type_desc,
            :sort_order => old_component_type.comp_type_sort_order,
            :has_costs => old_component_type.comp_type_has_costs,
            :has_hours => old_component_type.comp_type_has_hours,
            :has_vendor => old_component_type.comp_type_has_vendor,
            :has_totals => old_component_type.comp_type_has_misc,
            :in_totals_grid => old_component_type.comp_type_no_entry
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
      #ActiveRecord::Base.record_timestamps = false # turn off timestamps
      include Legacy::LegacyClasses
      # loop through the legacy records
      LegacyComponent.all.each do |old_component|
        begin
          # unique component_type found by description
          # old_component_type = LegacyComponentType.find(old_component.component_type_id)
          old_component_type = LegacyComponentType.find(old_component.comp_type_id)
          # new_component_type = ComponentType.find_by_description(old_component_type.description)
          new_component_type = ComponentType.find_by_description(old_component_type.comp_type_desc)
          if old_component.comp_lu_def_id.blank?
            new_default_id = nil
          else
            old_default = LegacyDefaults.find(old_component.comp_lu_def_id)
            new_default = Default.find_by_name(old_component_type.co_name)
            new_default_id = new_default.id
          end
          new_component = Component.new
          new_component.attributes = {
            :component_type_id => new_component_type.id,
            :description => old_component.comp_desc,
            :default_id => new_default_id,
            :editable => old_component.comp_calc_only,
            :deactivated => old_component.comp_deleted
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
            :description => old_table.sys_desc,
            :sort_order => old_table.sys_sort_order,
            :required => old_table.sys_required,
            :deactivated => old_table.sys_deleted
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
        old_component = LegacyComponent.find(old_table.sys_comp_comp_id)
        # unique component_type found by description
        # old_component_type = LegacyComponentType.find(old_component.component_type_id)
        old_component_type = LegacyComponentType.find(old_component.comp_type_id)
        # new_component_type = ComponentType.scoped_by_description(old_component_type.description).first
        new_component_type = ComponentType.scoped_by_description(old_component_type.comp_type_desc).first
        new_component = Component.where(:component_type_id => new_component_type.id, :description => old_component.comp_desc).first
        # unique assembly found by description
        old_assembly = LegacyAssembly.find(old_table.sys_comp_sys_id)
        new_assembly = Assembly.scoped_by_description(old_assembly.sys_desc).first
        begin
          new_table = AssemblyComponent.new
          # Rails.logger.debug("M migrating assembly_components AssemblyComponent component_id = #{new_component.id.to_s}, assembly_id = #{new_assembly.id.to_s}")
          new_table.attributes = {
            :component_id => new_component.id,
            :assembly_id => new_assembly.id,
            :description => (old_table.sys_comp_desc.nil?) ? '' : old_table.sys_comp_desc,
            :required => old_table.sys_comp_req,
            :deactivated => old_table.sys_comp_deleted
          }
          new_table.save!
          puts "Successfully migrated assembly_components record."
        rescue Exception => e
          Rails.logger.error("M Error migrating assembly_components record #{old_table.id.to_s},  #{e.inspect.to_s}")
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
            :name => old_table.tax_type_desc,
            :description => old_table.tax_type_desc,
            :sort_order => old_table.tax_type_sort_order
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
