namespace :data do
  desc "update random order for homepage artworks, grouped by artist/user"
  task randomize_artworks: :environment do
    rank = 0

    User.all.order("random()").each do |user|
      artworks = user.artworks
      artworks.each do |artwork|
        artwork.update_attribute(:non_search_rank, rank)
        rank += 1
      end
    end
  end
end
