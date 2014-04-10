require 'uri'
require 'net/http'
require 'json'
require 'mechanize'

class Device < ActiveRecord::Base

  def self.manufacturers_dashboard
    top_manufacturers = []
    Device.companies.each do |c|
      top_manufacturers.push({:label=> c, :value => Device.select("company = '#{c}'").count})
    end
    
    top_manufacturers
  end

  def self.total_Count
    Device.count
  end

  def self.top_hundred
    Device.order(updates: :desc).limit(100)
  end

  def self.companies
    Device.select("company").group("company").map{ |i| i.company }.compact
  end
  
  def self.reset_visits
    Device.update_all(updates: 1)
  end
  
  def set_manufacturer
    if self.company.nil? || self.company == ""
      self.company = self.get_manufacturer
    end
    
    #in case the above code fails to find the company then company will be ""
    if self.company == "" 
      self.company = self.get_manufacturer_from_site
    end
    
    self.save if self.company_changed?
  end
  
  def get_manufacturer
    uri = URI.parse("http://www.macvendorlookup.com/api/v2/#{self.macaddress}")
    response = Net::HTTP.get_response(uri)
    response.code != "200" ? "" : JSON.parse(response.body).first["company"]
  end
  
  def get_manufacturer_from_site
    agent = Mechanize.new

    page = agent.get("http://hwaddress.com/?q=#{self.macaddress}")
    link = page.links[7]
    link == nil ? "" : link.text
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
