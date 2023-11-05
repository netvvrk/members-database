require "test_helper"

class ArtworksControllerTest < ActionDispatch::IntegrationTest
  # setup do
  #   @artwork = artworks(:one)
  # end

  test "should get index" do
    get artworks_url
    assert_response :success
  end

  test "should get new" do
    get new_artwork_url
    assert_response :success
  end

  # test "should create artwork" do
  #   assert_difference("Artwork.count") do
  #     post artworks_url, params: { artwork: { depth: @artwork.depth, description: @artwork.description, duration: @artwork.duration, height: @artwork.height, location: @artwork.location, medium: @artwork.medium, price: @artwork.price, title: @artwork.title, units: @artwork.units, user_id: @artwork.user_id, visible: @artwork.visible, width: @artwork.width } }
  #   end

  #   assert_redirected_to artwork_url(Artwork.last)
  # end

  # test "should show artwork" do
  #   get artwork_url(@artwork)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_artwork_url(@artwork)
  #   assert_response :success
  # end

  # test "should update artwork" do
  #   patch artwork_url(@artwork), params: { artwork: { depth: @artwork.depth, description: @artwork.description, duration: @artwork.duration, height: @artwork.height, location: @artwork.location, medium: @artwork.medium, price: @artwork.price, title: @artwork.title, units: @artwork.units, user_id: @artwork.user_id, visible: @artwork.visible, width: @artwork.width } }
  #   assert_redirected_to artwork_url(@artwork)
  # end

  # test "should destroy artwork" do
  #   assert_difference("Artwork.count", -1) do
  #     delete artwork_url(@artwork)
  #   end

  #   assert_redirected_to artworks_url
  # end
end
