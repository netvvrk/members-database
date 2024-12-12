namespace :chargebee do
  desc "sync chargebee users"
  task sync: :environment do
    client = ChargebeeSync.new
    client.run
  end

  desc "[dry run] sync chargebee users"
  task dry_sync: :environment do
    client = ChargebeeSync.new
    client.dry_run
  end

  desc "sync a list of chargebee users"
  task sync_list: :environment do
    client = ChargebeeSync.new
    client.sync_list
  end
end
