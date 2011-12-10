# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

# fix heroku rake db:migrate problem
# per http://groups.google.com/group/rubyonrails-talk/browse_thread/thread/c4680a733fb1de81/666e4dc813bd91ba?show_docid=666e4dc813bd91ba
require 'rake/dsl_definition' 

TwsAuth::Application.load_tasks
