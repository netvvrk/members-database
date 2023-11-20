class Curator::ArtworksController < ApplicationController
  before_action :authenticate_user!
  before_action :confirm_curator

  # GET /curator/artworks
  def index
    @artworks = Artwork.all.limit(30)
  end

  # GET /curator/artworks/1
  def show
    @artwork = Artwork.find(params[:id])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_curator_artwork
    @curator_artwork = Curator::Artwork.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def curator_artwork_params
    params.fetch(:curator_artwork, {})
  end

  def confirm_curator
    current_user.show_browse?
  end
end
