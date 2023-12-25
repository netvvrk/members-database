require "test_helper"

class ArtworkTest < ActiveSupport::TestCase
  test "is_visible uses user's active flag" do
    user = users(:artist)
    user.update!(active: false)
    create_artwork(user)
    assert_equal 0, Artwork.is_visible.count
  end
end
