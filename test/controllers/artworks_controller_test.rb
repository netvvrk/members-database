require "test_helper"

class ArtworksControllerTest < ActionDispatch::IntegrationTest
  test "should get a redirect if not logged in" do
    get artworks_url
    assert_response :redirect
  end

  test "should load index if logged in as an artist" do
    sign_in users(:artist)
    get artworks_url
    assert_response :success
  end

  test "should load index if logged in as an admin" do
    sign_in users(:admin)
    get artworks_url
    assert_response :success
  end
end
