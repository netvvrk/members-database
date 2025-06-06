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

  desc "check subscription for a user"
  task check_sub: :environment do
    Util.check_subscription
  end

  desc "check inactive accounts"
  task check_inactive_accounts: :environment do
    Util.check_inactive_accounts
  end

  desc "delete old webhook events"
  task deleted_old_webhook_events: :environment do
    Util.deleted_old_webhook_events
  end
end
