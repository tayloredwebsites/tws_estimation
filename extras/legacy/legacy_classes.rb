# extras/legacy/legacy_classes.rb

module Legacy::LegacyClasses
  class LegacyDefaults < ActiveRecord::Base
    establish_connection :legacy
    self.table_name = 'defaults'
  end

end
