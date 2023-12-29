require "test_helper"

class ArtworkTest < ActiveSupport::TestCase
  test "is_visible uses user's active flag" do
    user = users(:artist)
    user.update!(active: false)
    create_artwork(user)
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
