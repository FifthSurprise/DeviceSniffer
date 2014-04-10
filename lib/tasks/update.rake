namespace :db do
  desc "Updates the companies in database based on mac address look-up"
  task :update_company => :environment do
    Device.where(:company => "").each do |d| 
      d.set_manufacturer 
    end
  end
end
