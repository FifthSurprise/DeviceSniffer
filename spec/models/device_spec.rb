require 'spec_helper'

describe Device do
  it 'creates a device entry' do
    d = Device.create(:macaddress => "00:18:0a:36:b6:2e", :rssi => "27")
    expect(Device.last).to eq (d)
  end
  it 'handles searching mac address that does not exist' do
    d = Device.create(:macaddress => "00:awiefj", :rssi => "27")
    expect(d.get_manufacturer).to eq ("")
  end

  it 'gets the manufacturer if available' do
    d = Device.create(:macaddress => "00:18:0a:36:b6:2e", :rssi => "27")
    d.get_manufacturer
    expect(d.company).to eq ("Meraki, Inc.")
  end

  it 'sets company to empty string if mac is nor parseable not available' do
    d = Device.create(:macaddress => "00awefdsf", :rssi => "27")
    d.get_manufacturer
    expect(d.company).to eq ("")
  end
end