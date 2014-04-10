require 'uri'
require 'net/http'
require 'json'

class Device < ActiveRecord::Base

  def self.manufacturers_dashboard
    top_manufacturers = []
    Device.companies.each do |c|
      top_manufacturers.push({:label=> c, :value => Device.where("company = '#{c}'").count})
    end
    return top_manufacturers
  end

  def self.total_Count
    Device.count
  end

  def self.top_hundred
    Device.order(updates: :desc).limit(100)
  end

  def self.companies
     # []<<Device.where("company != ''").group(:company).count.delete_if{|key,value| value<5}

    Device.where("company != ''").select("company").group("company").map{|i|i.company}
  end

  def get_manufacturer
    if (self.company.nil?)
      uri = URI.parse("http://www.macvendorlookup.com/api/v2/#{self.macaddress.downcase}")
      response = Net::HTTP.get_response(uri)
      if response.body == "" || response.body.nil?
        self.company = ""
      else
        self.company=JSON.parse(response.body).first["company"]
      end
      self.save
    end
    self.company
  end
  def self.reset_visits
    Device.update_all(updates: 1)
  end
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
