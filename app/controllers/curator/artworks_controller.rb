class Curator::ArtworksController < ApplicationController
  before_action :authenticate_user!
  before_action :confirm_curator

  # GET /curator/artworks
  def index
    @page = params[:page]&.to_i || 0
    @artworks = Artwork.is_visible.order(:id).all.page(@page)
  end

  # GET /curator/artworks/1
  def show
    @artwork = Artwork.find(params[:id])
  end

  private

  def confirm_curator
    current_user.show_browse?
  end
end
