require "test_helper"

class ArtworkTest < ActiveSupport::TestCase
  test "mark artworks as not visbile if user is deactivated" do
    user = users(:artist)
    create_artwork(user)
    assert_equal 1, Artwork.is_visible.count
    user.update!(active: false)
    assert_equal 0, Artwork.is_visible.count
  end

  test "search by artist name" do
    user = users(:artist)
    artwork = create_artwork(user)
    assert_equal [artwork], Artwork.search(user.name)
  end

  test "search by artwork title" do
    user = users(:artist)
    artwork = create_artwork(user)
    assert_equal [artwork], Artwork.search(artwork.title)
  end
end
