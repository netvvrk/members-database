class Curator::ArtworksController < ApplicationController
  before_action :authenticate_user!
  before_action :confirm_curator

  # GET /curator/artworks
  def index
    @page = params[:page]&.to_i || 0
    @search_term = params[:search]
    @artworks = Artwork.is_visible.with_images.all.page(@page)
    if @search_term.present?
      # with_pg_search_rank is to avoid sql error (see commit message)
      @artworks = @artworks.search(@search_term).with_pg_search_rank
      Rails.logger.debug(@artworks.to_sql)
    end
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
