require 'uri'
require 'net/http'
require 'json'

eventschedule = Dashing.scheduler.new(:max_work_threads => 5
  )
eventschedule.scheduler.every '10s', :allow_overlapping => false do
  ActiveRecord::Base.connection_pool.with_connection do
    eventschedule.send_event('past_hour',   { value: Device.sightings_past_hour })

    d = Device.where("company != ''").last
    company = d.company !="" ? d.company : "Device Manufacturer Not Found"
    eventschedule.send_event('last_MAC', { text: "#{company}",
                                     moreinfo: "MAC Address: #{d.macaddress}"})
    eventschedule.send_event('macaddresses',   { current: Device.total_Count })
    top_manufacturers=Device.manufacturers_dashboard
    eventschedule.send_event('manufacturers', {items: top_manufacturers})
    eventschedule.send_event('kcspeed', { text: "#{Movements.last.velocity} meters/second"})
    eventschedule.send_event('past_day',   { current: Device.sightings_past_day })
  end
  ActiveRecord::Base.connection_pool.release_connection
end
ActiveRecord::Base.connection_pool.release_connection

# Dashing.scheduler.every '5s',  :allow_overlapping => false do
#   ActiveRecord::Base.connection_pool.with_connection do
#   end
#   ActiveRecord::Base.connection_pool.release_connection
# end

# Dashing.scheduler.every '30s',  :allow_overlapping => false do
#   ActiveRecord::Base.connection_pool.with_connection do
#   end
#   ActiveRecord::Base.connection_pool.release_connection
# end


# Dashing.scheduler.every '60s',  :allow_overlapping => false do
#   ActiveRecord::Base.connection_pool.with_connection do
#   end
#   ActiveRecord::Base.connection_pool.release_connection
# end
