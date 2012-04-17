# extras/legacy/legacy_classes.rb

module Legacy::LegacyClasses
  class LegacyDefaults < ActiveRecord::Base
    establish_connection :legacy
    self.table_name = 'defaults'
  end
  class LegacyComponentType < ActiveRecord::Base
    establish_connection :legacy
    self.table_name = 'component_types'
  end
  class LegacyComponent < ActiveRecord::Base
    establish_connection :legacy
    self.table_name = 'components'
  end
  class LegacyAssembly < ActiveRecord::Base
    establish_connection :legacy
    self.table_name = 'assemblies'
  end
  class LegacyAssemblyComponent < ActiveRecord::Base
    establish_connection :legacy
    self.table_name = 'assembly_components'
  end
end
