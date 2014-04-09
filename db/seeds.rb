# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

d = Device.create(:macaddress => "00:18:0a:36:b6:2e", :rssi => "27")
d = Device.create(:macaddress => "68:94:23:80:d9:61", :rssi => "27")

