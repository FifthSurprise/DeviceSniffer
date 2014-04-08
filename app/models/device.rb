require 'uri'
require 'net/http'
require 'json'

class Device < ActiveRecord::Base
  def manufacturer
    uri = URI.parse("http://www.macvendorlookup.com/api/v2/#{self.macaddress}")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body).first["company"]
  end
end
