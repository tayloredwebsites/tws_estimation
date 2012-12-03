require 'rubygems'

# Set up gems listed in the Gemfile.
begin
  ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
  require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
  require 'rubygems'
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end

# require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
# require 'rubygems'
