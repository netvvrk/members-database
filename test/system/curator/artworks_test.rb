require "application_system_test_case"

class Curator::ArtworksTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit curator_artworks_url
    assert_selector "h1", text: "Artworks"
  end
end
