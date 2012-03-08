source 'http://rubygems.org'

gem 'rails', '3.2.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'pg'

gem 'cancan'

gem 'foreigner'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

group :development, :test do
  # gem 'rspec'
  # gem 'rspec-rails'
end

group :development do

  # To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
  # gem 'ruby-debug'
  gem 'ruby-debug19'
  
  gem 'rspec-rails'
  gem 'annotate'

end

group :test do

  gem 'rspec'
  
  gem 'capybara'
  gem 'launchy'
  
  # autotest config
  gem 'autotest'
  gem 'ZenTest'
  gem 'autotest-rails'
  gem 'autotest-growl'
  gem 'autotest-fsevent'

  # # guard config
  # gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  # gem 'guard-rspec'
  # gem 'guard-spork'
  # #gem 'growl_notify'

  # spork performance improvement to tests
  gem 'spork'
  
  # factory for testing
  gem 'factory_girl_rails'

  # To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
  # gem 'ruby-debug'
  gem 'ruby-debug19'
  
  # see spec/spec_helper.rb - for fix of test records not removed after capybara fill_in and click
  gem 'database_cleaner'
  
end
