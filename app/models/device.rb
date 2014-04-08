class Device < ActiveRecord::Base
  def self.total_Count
     Device.count
  end
end
