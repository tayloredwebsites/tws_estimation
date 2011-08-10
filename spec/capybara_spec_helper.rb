# spec/capybara_spec_helper.rb
# This file enhances the spec_helper.rb file with capybara functionality

###############################
# Config
###############################
# Add this to load Capybara:
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/dsl'

# not sure if this is needed 
# see http://techiferous.com/2010/04/using-capybara-in-rails-3/
# additionally got :`include Capybara` is deprecated please use `include Capybara::DSL` instead.
module ActionController
  class IntegrationTest
    include Capybara::DSL
  end
end