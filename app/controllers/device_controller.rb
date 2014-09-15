class DeviceController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  SECRET = 'foobar'

  def event
    @validator = "2a70b50ea6b2095b5f79c9874c9352040ccdedc1"
    render :text => @validator
    # respond_to do |format|
    #   format.html
    #   format.json { render :text => "#{@validator}" }
    # end
  end

  def postevent
    #temporarily taking out post event
  #         #code crap
  #     DB_COUNTER.connection_count += 1
  #     puts "CONNECTING TO DATABASE: #{ActiveRecord::Base.connection_pool.size} connections."
  #     puts "Connection pool is : #{ActiveRecord::Base.connection_pool}"
  #     ActiveRecord::Base.connection_pool.with_connection do


  #   map = JSON.parse(params[:data])
  #   # if map['secret'] != SECRET
  #   #   logger.warn "got post with bad secret: #{SECRET}"
  #   #   return
  #   # end
  #   map['probing'].each do |c|
  #     mac = c['client_mac'].sub(%r[ (.+) UTC (\d+)],"").gsub("\"","")
  #     apmac = c['ap_mac'].sub(%r[ (.+) UTC (\d+)],"").gsub("\"","")
  #     rssi = c['rssi']



  #     d = Device.find_by(macaddress: mac)  #DB1
  #     # puts ("looking at #{mac}")
  #     #create a device entry from the macaddress
  #     if d.nil?
  #       d = Device.create(:macaddress => mac,
  #                         :accesspoint => apmac,
  #                         :rssi => rssi,
  #                         :updates=>1) #db2
  #       d.set_manufacturer
  #     else
  #       if d.updated_at + (5) < Time.now
  #         if (mac == "5C:0A:5B:4D:B9:72".downcase && d.accesspoint != apmac)
  #           if (rssi.to_i > 35)
  #             puts ("Found Kevin!!!!")
  #             # puts ("Device is #{d.macaddress}")
  #             puts ("AP is #{apmac} to replace #{d.accesspoint}")
  #             velocity = (Time.now.to_i - d.updated_at.to_i)/60.0/25.0
  #             Movements.create(:macaddress => mac, :velocity => "#{velocity}") #Db2
  #             puts ("Difference is #{velocity}")
  #             puts ("Speed is #{(Time.now.to_i - d.updated_at.to_i)/60/100}")
  #           end
  #         end
  #         d.accesspoint = apmac 
  #         d.updated_at = Time.now
  #         d.updates+=1
  #         d.save
  #       end
  #     end
  #     # logger.info "client #{c['client_mac']} seen on ap #{c['ap_mac']} with rssi #{c['rssi']} at #{c['last_seen']}"
  #   end

  #   #found Kevin Chang
  # end
  # DB_COUNTER.connection_count -= 1
  # puts "Finished processing mac addresses"
  # puts "RELEASING DATABASE CONNECTION: #{ActiveRecord::Base.connection_pool.size} connections."

    redirect_to '/event'
  end

  def events
    @count = Device.total_Count
    @events= Device.top_hundred
  end

end
