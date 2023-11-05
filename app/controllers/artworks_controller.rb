class ArtworksController < ApplicationController
  before_action :set_artwork, only: %i[ show edit update destroy ]

  # GET /artworks
  def index
    @artworks = Artwork.all
  end

  # GET /artworks/1
  def show
  end

  # GET /artworks/new
  def new
    @artwork = Artwork.new
  end

  # GET /artworks/1/edit
  def edit
  end

  # POST /artworks
  def create
    @artwork = Artwork.new(artwork_params)

    if @artwork.save
      redirect_to @artwork, notice: "Artwork was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /artworks/1
  def update
    if @artwork.update(artwork_params)
      redirect_to @artwork, notice: "Artwork was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /artworks/1
  def destroy
    @artwork.destroy!
    redirect_to artworks_url, notice: "Artwork was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artwork
      @artwork = Artwork.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def artwork_params
      params.require(:artwork).permit(:title, :medium, :description, :price, :visible, :duration, :units, :height, :width, :depth, :location, :user_id)
    end
end
