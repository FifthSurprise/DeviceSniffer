class Device < ActiveRecord::Base
  def self.total_Count
     Device.count
  end

  def self.top_hundred
    Device.order(updates: :desc).limit(100)
  end
end
