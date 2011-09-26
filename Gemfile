source 'http://rubygems.org'

gem 'rails', '3.0.10'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3-ruby', :require => 'sqlite3'

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
  # gem 'autotest'
  # gem 'ZenTest'
  # gem 'autotest-rails'
  # gem 'autotest-growl'
  # gem 'autotest-fsevent'

  # guard config
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'guard-rspec'
  gem 'guard-spork'
  
  # spork performance improvement to tests
  gem 'spork'
  
  # factory for testing
  gem 'factory_girl_rails'

  # To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
  # gem 'ruby-debug'
  gem 'ruby-debug19'
  
end
