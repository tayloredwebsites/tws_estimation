# lib/tasks/legacy.rake

namespace :legacy do

  namespace :convert do

    desc 'import all legacy data'
    task :all => [:setups, :defaults, :component_types ]

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
      LegacyComponentTypes.all.each do |old_component_type|
        begin
          new_component_type = ComponentType.new
          new_component_type.attributes = {
            :description => old_component_type.description,
            :sort_order => old_component_type.sort_order,
            :has_costs => old_component_type.has_costs,
            :has_hours => old_component_type.has_hours,
            :has_vendor => old_component_type.has_vendor,
            :has_misc => old_component_type.has_misc,
            :no_entry => old_component_type.no_entry,
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
    
    
  end    # end :convert namespace
  
end
