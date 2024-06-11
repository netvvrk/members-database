namespace :chargebee do
  desc "sync chargebee users"
  task sync: :environment do
    client = ChargebeeSync.new
    client.run
  end
end
