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
    it "should update for the same mac address" do
      request.env["HTTP_ACCEPT"] = "event"
      post 'postevent', :data=> {"secret"=>"foobar",
                                 "probing"=>[{"ap_mac"=>"00:18:0a:36:b6:2e",
                                              "client_mac"=>"8c:58:77:2c:f4:48 20:36:04.396 UTC 2013",
                                              "rssi"=>"27"},
                                             {"ap_mac"=>"00:18:0a:36:b6:2e",
                                              "client_mac"=>"8c:58:77:2c:f4:48 20:36:05.396 UTC 2013",
                                              "rssi"=>"23"}]
                                 }.to_json
      expect(Device.find_by(:macaddress =>"8c:58:77:2c:f4:48").updates).to eq(2)
    end
    it 'should keep track of total visitors' do
      post 'postevent', :data=> {"secret"=>"foobar",
                                 "probing"=>[{"ap_mac"=>"01:18:0a:36:b6:2e",
                                              "client_mac"=>"3c:58:77:2c:f4:48 20:36:04.396 UTC 2013",
                                              "rssi"=>"27"},
                                             {"ap_mac"=>"02:18:0a:36:b6:2e",
                                              "client_mac"=>"4c:58:77:2c:f4:48 20:36:05.396 UTC 2013",
                                              "rssi"=>"23"}]
                                 }.to_json
      post 'postevent', :data=> {"secret"=>"foobar",
                                 "probing"=>[{"ap_mac"=>"03:18:0a:36:b6:2e",
                                              "client_mac"=>"5c:58:77:2c:f4:48 20:36:04.396 UTC 2013",
                                              "rssi"=>"27"},
                                             {"ap_mac"=>"04:18:0a:36:b6:2e",
                                              "client_mac"=>"6c:58:77:2c:f4:48 20:36:05.396 UTC 2013",
                                              "rssi"=>"23"}]
                                 }.to_json
      post 'postevent', :data=> {"secret"=>"foobar",
                                 "probing"=>[{"ap_mac"=>"05:18:0a:36:b6:2e",
                                              "client_mac"=>"7c:58:77:2c:f4:48 20:36:04.396 UTC 2013",
                                              "rssi"=>"27"},
                                             {"ap_mac"=>"06:18:0a:36:b6:2e",
                                              "client_mac"=>"8c:58:77:2c:f4:48 20:36:05.396 UTC 2013",
                                              "rssi"=>"23"}]
                                 }.to_json
      expect(Device.total_Count).to eq(6)

    end
  end
end
