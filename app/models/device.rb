require 'uri'
require 'net/http'
require 'json'

class Device < ActiveRecord::Base
  def manufacturer
    uri = URI.parse("http://www.macvendorlookup.com/api/v2/#{self.macaddress}")
    response = Net::HTTP.get_response(uri)
    response.body == "" ? "" : JSON.parse(response.body).first["company"]
  end
  
  def self.generate_names(num)
    animals = File.readlines("lib/naming/animals.txt")
    adjectives = File.readlines("lib/naming/adjectives.txt")
    
    File.open("lib/naming/names.txt", "w") do |file|
      num.times do 
        to_add = adjectives.sample.strip + "-" + animals.sample.strip + "-"+ "#{rand(10..99)}" +"\n"
        file.write(to_add)
      end
    end
  end
  
  def self.get_name
    self.generate_names(100000) unless File.readlines("lib/naming/names.txt").count > 0
    
    File.readlines("lib/naming/names.txt").sample.strip
  end
end

