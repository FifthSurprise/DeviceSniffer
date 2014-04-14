require 'uri'
require 'net/http'
require 'json'

Dashing.scheduler.every '10s', :allow_overlapping => false do
  ActiveRecord::Base.connection_pool.with_connection do
    Dashing.send_event('past_hour',   { value: Device.sightings_past_hour })

    d = Device.where("company != ''").last
    company = d.company !="" ? d.company : "Device Manufacturer Not Found"
    Dashing.send_event('last_MAC', { text: "#{company}",
                                     moreinfo: "MAC Address: #{d.macaddress}"})
  end
  ActiveRecord::Base.connection_pool.release_connection
end

Dashing.scheduler.every '5s',  :allow_overlapping => false do
  ActiveRecord::Base.connection_pool.with_connection do
    Dashing.send_event('macaddresses',   { current: Device.total_Count })
  end
  ActiveRecord::Base.connection_pool.release_connection
end

Dashing.scheduler.every '30s',  :allow_overlapping => false do
  ActiveRecord::Base.connection_pool.with_connection do
    top_manufacturers=Device.manufacturers_dashboard
    Dashing.send_event('manufacturers', {items: top_manufacturers})
    Dashing.send_event('kcspeed', { text: "#{Movements.last.velocity} meters/second"})
  end
  ActiveRecord::Base.connection_pool.release_connection
end


Dashing.scheduler.every '60s',  :allow_overlapping => false do
  ActiveRecord::Base.connection_pool.with_connection do
    Dashing.send_event('past_day',   { current: Device.sightings_past_day })
  end
  ActiveRecord::Base.connection_pool.release_connection
end
