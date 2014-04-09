require 'uri'
require 'net/http'
require 'json'

class Device < ActiveRecord::Base

  def self.total_Count
    Device.count
  end

  def self.top_hundred
    Device.order(updates: :desc).limit(100)
  end

  def self.companies
    Device.select("company").group("company").map{|i|i.company}.compact
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
end
