namespace :migrate do
  desc "migrate user names to profiles"
  task names: :environment do
    User.find_in_batches do |group|
      group.each do |user|
        profile = user.profile || Profile.new(user_id: user.id)
        profile.name = user.name
        profile.save!
      end
    end
  end
end
