require 'uri'
require 'net/http'
require 'json'
# require_relative '../models/device.rb'

current_valuation = 0

Dashing.scheduler.every '3s' do
  last_valuation = current_valuation
  current_valuation = rand(100)

  Dashing.send_event('valuation', { current: current_valuation, last: last_valuation })
  Dashing.send_event('macaddresses',   { current: Device.total_Count })
  Dashing.send_event('past_hour',   { value: Device.sightings_past_hour })
  Dashing.send_event('past_day',   { current: Device.sightings_past_day })
  d = Device.last
  Dashing.send_event('last_MAC', { text: "#{d.company}",
                                   moreinfo: "MAC Address: #{d.macaddress}"})


  Dashing.send_event('convergence', { current: Device.sightings_past_hour})


  #top_manufacturers  = [{:label=>"Apple", :value=>50}, { :label=>"HTC", :value=>20}, {:label=>'Samsung', :value=>22}]
  # top_manufacturers=[]
  top_manufacturers=Device.manufacturers_dashboard
  Dashing.send_event('manufacturers', {items: top_manufacturers})
end
