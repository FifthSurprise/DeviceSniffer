require 'uri'
require 'net/http'
require 'json'
require_relative '../models/device.rb'

current_valuation = 0

Dashing.scheduler.every '5s' do
  last_valuation = current_valuation
  current_valuation = rand(100)

  Dashing.send_event('valuation', { current: current_valuation, last: last_valuation })
  Dashing.send_event('macaddresses',   { value: Device.total_Count })

  
  buzz  = [{:label=>"Apple", :value=>50}, { :label=>"HTC", :value=>20}, {:label=>'Samsung', :value=>22}]
  Dashing.send_event('top3devices', {items: buzz})
end