namespace :data do
  desc "update random order for homepage artworks"
  task randomize_artworks: :environment do
    ActiveRecord::Base.connection.execute("update artworks set non_search_rank = random()")
  end
end
