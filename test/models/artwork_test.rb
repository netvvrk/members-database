require "test_helper"

class ArtworkTest < ActiveSupport::TestCase
  test "mark artworks as not active if user is deactivated" do
    user = users(:artist)
    artwork = create_artwork(user)
    assert artwork.active
    user.update!(active: false)
    refute artwork.reload.active
  end

  test "search by artist name" do
    user = users(:artist)
    artwork = create_artwork(user)
    assert_equal [artwork], Artwork.search(user.profile.name)
  end

  test "search by artwork title" do
    user = users(:artist)
    artwork = create_artwork(user)
    assert_equal [artwork], Artwork.search(artwork.title)
  end
end
