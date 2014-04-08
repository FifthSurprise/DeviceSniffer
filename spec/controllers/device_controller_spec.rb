require 'spec_helper'

describe DeviceController do
  describe "POST 'events'" do
    it "should be successful" do
      request.env["HTTP_ACCEPT"] = "event"
      post 'postevent', :data=> {"secret"=>"foobar",
                   "probing"=>[{"ap_mac"=>"00:18:0a:36:b6:2e",
                               "client_mac"=>"8c:58:77:2c:f4:48 20:36:04.396 UTC 2013",
                               "rssi"=>"27"},
                              {"ap_mac"=>"00:18:0a:36:b6:2e",
                               "client_mac"=>"8c:58:37:1d:f4:49 20:36:04.396 UTC 2013",
                               "rssi"=>"22"}]
                   }.to_json
                   expect(Device.last.macaddress).to eq("8c:58:37:1d:f4:49")
    end
  end
end
