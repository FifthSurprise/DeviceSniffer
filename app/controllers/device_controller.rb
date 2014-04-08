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
      mac = c['client_mac'].sub(%r[ (.+) UTC (\d+)],"")

      d = Device.find_by(macaddress: mac)
      #create a device entry from the macaddress
      if d.nil?
        d = Device.create(:macaddress => mac, :rssi => c['rssi'], :updates=>1)
      else
        d.updated_at = Time.now
        d.updates+=1
        d.save
      end
      # logger.info "client #{c['client_mac']} seen on ap #{c['ap_mac']} with rssi #{c['rssi']} at #{c['last_seen']}"
    end
    redirect_to '/event'
  end

  def events
    @events=Device.all
  end
end
