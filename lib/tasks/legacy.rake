# lib/tasks/legacy.rake

namespace :legacy do

  namespace :convert do

    desc 'import all legacy data'
    task :all => [:setups, :defaults ]

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
  end
  
end
