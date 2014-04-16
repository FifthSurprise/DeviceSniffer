require 'uri'
require 'net/http'
require 'json'

Dashing.scheduler.every '10s', :allow_overlapping => false do
  DB_COUNTER.connection_count += 1
  puts "CONNECTING TO DATABASE: #{DB_COUNTER.connection_count} connections."
  puts "Connection pool is : #{ActiveRecord::Base.connection_pool}"
  ActiveRecord::Base.connection_pool.with_connection do
    Dashing.send_event('past_hour',   { value: Device.sightings_past_hour })

    d = Device.where("company != ''").last
    company = d.company !="" ? d.company : "Device Manufacturer Not Found"
    Dashing.send_event('last_MAC', { text: "#{company}",
                                     moreinfo: "MAC Address: #{d.macaddress}"})
    Dashing.send_event('macaddresses',   { current: Device.total_Count })
    top_manufacturers=Device.manufacturers_dashboard
    Dashing.send_event('manufacturers', {items: top_manufacturers})
    # Dashing.send_event('kcspeed', { text: "#{Movements.last.velocity} meters/second"})
    Dashing.send_event('past_day',   { current: Device.sightings_past_day })
  end
  ActiveRecord::Base.connection_pool.release_connection
  DB_COUNTER.connection_count -= 1
  puts "RELEASING DATABASE CONNECTION: #{DB_COUNTER.connection_count} connections."
end
# ActiveRecord::Base.connection_pool.release_connection
# puts "!!!!RELEASING DATABASE CONNECTION 2!!!!"

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
