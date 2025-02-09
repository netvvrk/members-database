class ArtworksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_artwork, only: %i[show edit update destroy move_artwork]
  skip_before_action :verify_authenticity_token, only: %i[move_artwork]  

  # GET /artworks
  def index
    @artworks = current_user.artworks
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
    redirect_to artworks_url, notice: "You have uploaded the maximum number of artworks" unless current_user.more_artworks_allowed?

    @artwork = Artwork.new(artwork_params)
    @artwork.user = current_user

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

  # PATCH /artworks/1/move_artwork
  def move_artwork
    new_position = params[:to_index].to_i + 1
    @artwork.update position: new_position
    render json: {}, status: 200
  end  

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_artwork
    @artwork = current_user.artworks.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def artwork_params
    params.require(:artwork).permit(:title, :medium, :material, :description, :price, :visible, :duration, :units, :height, :width, :depth, :location, :user_id, :year, :edition)
  end
end
