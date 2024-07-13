namespace :migrate do
  desc "migrate user names to profiles"
  task names: :environment do
    User.find_in_batches do |group|
      group.each do |user|
        profile = user.profile || user.profile.new
        profile.name = user.name
        profile.save!
      end
    end
  end
end
