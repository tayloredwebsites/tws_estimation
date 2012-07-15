#  testing using sqlite3 in memory database - force schema to load
# http://calicowebdev.com/2011/01/25/rails-3-sqlite-3-in-memory-databases/
def in_memory_database?
  Rails.env == "test" and
    defined?(ActiveRecord::ConnectionAdapters::SQLite3Adapter) and
    ActiveRecord::Base.connection.class == ActiveRecord::ConnectionAdapters::SQLite3Adapter and
    Rails.configuration.database_configuration['test']['database'] == ':memory:'
end

def in_memory_load_db_schema(silent=true)
  if in_memory_database?
    puts "creating sqlite in memory database"
    load "#{::Rails.root}/db/schema.rb" # use db agnostic schema by default
    # ActiveRecord::Migrator.up('db/migrate') # use migrations
    
    # # enforce foreign keys
    # # http://www.sqlite.org/foreignkeys.html
    # # http://osdir.com/ml/RubyonRailsTalk/2009-05/msg01718.html
    # c = ::ActiveRecord::Base.connection
    # resp = c.execute("PRAGMA foreign_keys = ON")
    # Rails.logger.debug("INIT - in_memory_load_db_schema foreign keys pragma returned: #{resp.inspect.to_s}")
    
    # # https://github.com/dwilkie/foreigner#readme
    # rails dbconsole
    # .genfkey —exec
    
  end
end
