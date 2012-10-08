# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


User.create(:username => 'AdminUser',
  :first_name => 'Admin',
  :last_name => 'User',
  :email => 'admin@example.com',
  :roles => 'all_admins guest_users',
  :password => 'test',
  :password_confirmation => 'test'
)

User.create(:username => 'TestUser',
  :first_name => 'Test',
  :last_name => 'User',
  :email => 'test@example.com',
  :roles => 'maint_users guest_users',
  :password => 'test',
  :password_confirmation => 'test'
)

