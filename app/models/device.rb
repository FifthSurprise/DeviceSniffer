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
    
    [].tap do |names|
      num.times do 
        names << adjectives.sample.strip + "-" + animals.sample.strip + "-"+ "#{rand(10..99)}"
      end
    end
  end
  
  def self.get_name
    names = self.generate_names(3)
    name = names.sample
    
    File.open("lib/naming/names.txt", "a") do |file|
      file.write(name + "\n")
    end
    
    name
  end
end

