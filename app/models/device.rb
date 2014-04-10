require 'uri'
require 'net/http'
require 'json'

class Device < ActiveRecord::Base

  def self.sightings_past_hour
    #(Time.now.to_time-1.hours).to_datetime.in_time_zone("Eastern Time (US & Canada)")
    Device.where(["created_at >= ?", Time.now-3600]).count
  end

  def self.sightings_past_day
    Device.where(["created_at >= ?", Time.now-86400]).count
  end

  def self.manufacturers_dashboard
    top_manufacturers = []
    Device.where("company != ''").group(:company).count.each do |key,value|
      if (value>5)
        top_manufacturers.push({:label=> key, :value => value})
      end
    end
    # top_manufacturers.push(Device.where("company != ''").group(:company).count.delete_if{|key,value| value<0})
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
