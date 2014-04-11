require 'uri'
require 'net/http'
require 'json'
require 'mechanize'

class Device < ActiveRecord::Base

  def self.sightings_past_hour
    #(Time.now.to_time-1.hours).to_datetime.in_time_zone("Eastern Time (US & Canada)")
    Device.where(["updated_at >= ?", Time.now-3600]).count
  end

  def self.sightings_past_day
    Device.where(["updated_at >= ?", Time.now-86400]).count
  end

  def self.manufacturers_dashboard
    top_manufacturers = []
    Device.where("company != ''").group(:company).count.each do |key,value|
      if (value>100)
        top_manufacturers.push({:label=> key, :value => value})
      end
    end
    top_manufacturers.sort!{|a,b| b[:value] <=> a[:value]}
    # top_manufacturers.push(Device.where("company != ''").group(:company).count.delete_if{|key,value| value<0})
    final = []
    #iterate through array of the manufacturers sorted
    #manufacturers have a label and a value
    top_manufacturers.each do |company|
      companyfound = false
      final.each do |altcompany|
        companyname = company[:label].downcase.gsub(/[^a-z\s]/, '')
        altcompanyname = altcompany[:label].downcase.gsub(/[^a-z\s]/, '')
        if (companyname.start_with?(altcompanyname) || altcompanyname.start_with?(companyname))
          altcompany[:value] += company[:value]
          companyfound = true
        end
      end
      unless companyfound
        final.push(company)
      end
    end
    return final
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

  #Working on scraping from router for those joining flatiron guest
  # https://n74.meraki.com/The-Flatiron-Sch/n/3uhZbbkb/manage/usage/logins?ssid=0&timespan=2592000
  # def self.parse_latest_router
  #   agent = Mechanize.new
  #   page = agent.get("https://n74.meraki.com/The-Flatiron-Sch/n/3uhZbbkb/manage/usage/logins?ssid=0&timespan=2592000")

  # end
end
