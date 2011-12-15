# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


User.create(:first_name => 'admin',
  :last_name => 'User',
  :email => 'admin@example.com',
  :username => 'AdminUser',
  :roles => 'all_admins all_guests',
  :password => 'test',
  :password_confirmation => 'test'
)

User.create(:first_name => 'test',
  :last_name => 'User',
  :email => 'test@example.com',
  :username => 'TestUser',
  :roles => 'all_guests maint_users',
  :password => 'test',
  :password_confirmation => 'test'
)

