# extras/legacy/legacy_classes.rb

module Legacy::LegacyClasses
  class LegacyDefaults < ActiveRecord::Base
    establish_connection :legacy
    self.table_name = 'defaults'
  end
  class LegacyComponentTypes < ActiveRecord::Base
    establish_connection :legacy
    self.table_name = 'component_types'
  end
end
