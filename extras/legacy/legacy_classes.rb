# extras/legacy/legacy_classes.rb

module Legacy::LegacyClasses
  class LegacyDefaults < ActiveRecord::Base
    establish_connection :legacy
    self.table_name = 'defaults'
    # set primary_key to prevent "Unknown bind columns. We can account for this." in sqlserver adapter
    self.primary_key = 'co_id'
  end
  class LegacyComponentType < ActiveRecord::Base
    establish_connection :legacy
    # self.table_name = 'component_types'
    self.table_name = 'componenttypes'
    # set primary_key to prevent "Unknown bind columns. We can account for this." in sqlserver adapter
    self.primary_key = 'comp_type_id'
  end
  class LegacyComponent < ActiveRecord::Base
    establish_connection :legacy
    self.table_name = 'components'
    # set primary_key to prevent "Unknown bind columns. We can account for this." in sqlserver adapter
    self.primary_key = 'comp_id'
  end
  class LegacyAssembly < ActiveRecord::Base
    establish_connection :legacy
    # self.table_name = 'assemblies'
    self.table_name = 'systems'
    # set primary_key to prevent "Unknown bind columns. We can account for this." in sqlserver adapter
    self.primary_key = 'sys_id'
  end
  class LegacyAssemblyComponent < ActiveRecord::Base
    establish_connection :legacy
    # self.table_name = 'assembly_components'
    self.table_name = 'systemcomponents'
    # set primary_key to prevent "Unknown bind columns. We can account for this." in sqlserver adapter
    self.primary_key = 'sys_comp_id'
  end
  class LegacyJobType < ActiveRecord::Base
    establish_connection :legacy
    # self.table_name = 'job_types'
    self.table_name = 'taxtypes'
    # set primary_key to prevent "Unknown bind columns. We can account for this." in sqlserver adapter
    self.primary_key = 'tax_type_id'
  end
end
