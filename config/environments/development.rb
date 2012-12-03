TwsAuth::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  # config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false
  # config.cache_store = :mem_cache_store, "localhost"

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  # config.active_record.mass_assignment_sanitizer = :strict
  config.active_record.mass_assignment_sanitizer = :logger

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # custom config settings # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  
  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # specify logger and set to debug
  config.logger = Logger.new(STDOUT)  #default
  # See everything in the log (default is :info)
  config.log_level = :debug
  LOGGING = true  #default

  # precompile assets before running test suite
  # see: http://stackoverflow.com/questions/13484808/save-and-open-page-not-working-with-capybara-2-0
  # config.assets.prefix = "assets_dev"    # place test assets in public/assets_dev directory
  # config.action_controller.asset_host = "file://#{::Rails.root}/public"
  #   # Don't fallback to assets pipeline if a precompiled asset is missed
  #   config.assets.compile = false
  #   # Generate digests for assets URLs
  #   config.assets.digest = false
  #   # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  #   # config.assets.precompile += %w[xxx.js] #Lots of other space separated files
  #   config.assets.precompile += %w( *.js *.scss *.coffee *.css )
  #   # Enable serving of images, stylesheets, and javascripts from an asset server
  #   # config.action_controller.asset_host = "http://assets.example.com"
  #   config.assets.manifest = Rails.root.join("public/assets")

  # custom config settings # # # # # # # # # # # # # # # # # # # # # # # # # # # #

end
