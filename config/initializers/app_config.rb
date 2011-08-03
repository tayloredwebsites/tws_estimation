# app_config.rb
# file to load up application and current environment values from a config file

ENV_CONFIG = YAML.load_file("#{::Rails.root.to_s}/config/app_config.yml")[::Rails.env] || {}
    # YAML.load_file loads in a yml file into a hash
    # ::Rails.root.to_s replaces RAILS_ROOT, and points to the directory of the site root.
    # config/app_config.yml holds the config information in the usual place in convinient YAML/yml format.
    # [::Rails.env] pulls out that hash value (development/production/test - used to be RAILS_ENV), which corresponds to the corresponding section in the yml file
    # || {} prevents a null hash from being created - creates an empty one if null
APP_CONFIG = YAML.load_file("#{::Rails.root.to_s}/config/app_config.yml")["application"] || {}
    # ditto
    # ["all_environments"] pulls out that hash value, which corresponds to the corresponding all_environments: section in the yml file
APP_CONFIG.update(ENV_CONFIG)
    # merges the ENV_CONFIG hash into the APP_CONFIG hash, overwriting APP_CONFIG if duplicated
    # thus the environment specific values will overwrite the application level values
