require "test_helper"

class ArtistsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    artist = users(:artist)
    get artist_url(artist)
    assert_response :success
  end
end
