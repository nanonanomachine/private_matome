# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.create(:email => 'test@test.com', :password => '123456789a', :password_confirmation => '123456789a', :role => 'admin')
user.save!

user_second = User.create(:email => 'test_second@test.com', :password => '123456789a', :password_confirmation => '123456789a')
user_second.save!

user_third = User.create(:email => 'test_third@test.com', :password => '123456789a', :password_confirmation => '123456789a')
user_third.save!

group = Group.create(:name => 'test group', :description => 'test description', :link => 'http://www.google.com', :privacy => 'open')
group.save!

group_second = Group.create(:name => 'test_second group', :description => 'test_second description', :link => 'http://www.google.com', :privacy => 'close')
group_second.save!

group_third = Group.create(:name => 'test_third group', :description => 'test_third', :link => 'http://www.google.com', :privacy => 'secret')
group_third.save!

group.admins << user
group_second.admins << user
group_second.members << user_second
group_third.admins << user_second