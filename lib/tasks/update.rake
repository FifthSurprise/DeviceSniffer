namespace :update do
  desc "Updates to database"
  task manufacturerquery: :environment do
    Device.where("company is null").each{|d|puts d.macaddress}
  end
end
