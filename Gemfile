source 'http://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# gem 'sqlite3-ruby', :require => 'sqlite3'

# for Postgres
gem 'pg'

# # for SQL Server
# gem 'tiny_tds'
# gem "activerecord-sqlserver-adapter", "~> 3.2.0"
# gem "ruby-odbc"   #, "~> 0.99994"

gem 'cancan'

gem 'foreigner' # foreign key handling

gem 'rdiscount'	# markdown files display in view # removed for win/xp? issues

gem 'jquery-rails'

# don't use webbrick on windows, Use thin all environments
# see http://www.psteiner.com/2012/04/how-to-replace-webrick-with-thin-for.html
# c:>gem install eventmachine --pre
# c:>gem install thin
gem 'thin'  # makes thin the default web server
# Use unicorn as the web server - *nix only?
# gem 'unicorn'

gem 'newrelic_rpm'

# Deploy with Capistrano
# gem 'capistrano'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# added for heroku
group :assets do
  gem 'uglifier'
end

group :development, :test do
  # gem 'rspec'
  gem 'rspec-rails', "~> 2.0"
end

group :development do

  gem 'debugger', '~> 1.6.1'

  gem 'annotate'

end

group :test do

  # gem 'capybara', '~> 1.1'
  gem 'capybara', '~> 2.0'
  # gem 'capybara-screenshot'
  gem 'launchy'
  gem 'shoulda-matchers'

  # autotest config
  # gem 'autotest'
  # gem 'ZenTest'
  # gem 'autotest-rails'
  # gem 'autotest-growl'
  # gem 'autotest-fsevent'

  # # guard config
  # gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  # gem 'guard-rspec'
  # gem 'guard-spork'
  # #gem 'growl_notify'

  # spork performance improvement to tests
  gem 'spork'

  # gem 'sqlite3-ruby', :require => 'sqlite3'  - no good for inmemory testing - can't turn on foreign key validations

  # factory for testing
  gem 'factory_girl_rails'

  # To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
  # gem 'ruby-debug'
  # gem 'ruby-debug19' # removed for windows install

  # see spec/spec_helper.rb - for fix of test records not removed after capybara fill_in and click
  gem 'database_cleaner'

end
