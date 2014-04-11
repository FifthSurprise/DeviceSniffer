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
    map = JSON.parse(params[:data])
    # if map['secret'] != SECRET
    #   logger.warn "got post with bad secret: #{SECRET}"
    #   return
    # end
    map['probing'].each do |c|
      mac = c['client_mac'].sub(%r[ (.+) UTC (\d+)],"").gsub("\"","")
      apmac = c['ap_mac'].sub(%r[ (.+) UTC (\d+)],"").gsub("\"","")
      d = Device.find_by(macaddress: mac)
      # puts ("looking at #{mac}")
      #create a device entry from the macaddress
      if d.nil?
        d = Device.create(:macaddress => mac,
                          :accesspoint => apmac,
                          :rssi => c['rssi'],
                          :updates=>1)
        d.set_manufacturer
      else
        if d.updated_at + (5) < Time.now
          if (mac == "5C:0A:5B:4D:B9:72".downcase && d.accesspoint != apmac)
            # puts ("Found Kevin!!!!")
            # puts ("Device is #{d.macaddress}")
            # puts ("AP is #{apmac} to replace #{d.accesspoint}")
            Movements.create(:macaddress => mac,
                             :velocity => (Time.now.to_i - d.updated_at.to_i)/60/100)
          end
          d.accesspoint = apmac
          d.updated_at = Time.now
          d.updates+=1
          d.save
        end
      end
      # logger.info "client #{c['client_mac']} seen on ap #{c['ap_mac']} with rssi #{c['rssi']} at #{c['last_seen']}"
    end

    #found Kevin Chang


    redirect_to '/event'
  end

  def events
    @count = Device.total_Count
    @events= Device.top_hundred
  end

end
