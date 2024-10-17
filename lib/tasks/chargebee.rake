namespace :chargebee do
  desc "sync chargebee users"
  task sync: :environment do
    client = ChargebeeSync.new
    client.run
  end

  desc "sync a list of chargebee users"
  task sync: :environment do
    client = ChargebeeSync.new
    client.sync_list
  end
end
