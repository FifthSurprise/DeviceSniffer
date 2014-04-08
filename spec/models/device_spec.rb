require 'spec_helper'

describe Device do
  it 'creates a device entry' do
    d = Device.create(:macaddress => "00:18:0a:36:b6:2e", :rssi => "27")
    expect(Device.last).to eq (d)
  end
end

