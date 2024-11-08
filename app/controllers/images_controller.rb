class ImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_artwork
  before_action :set_image, only: %i[show edit update destroy move_image]
  skip_before_action :verify_authenticity_token, only: %i[move_image]

  # GET /images
  def index
    @images = @artwork.images
  end

  # GET /images/1
  def show
  end

  # GET /images/new
  def new
    @image = @artwork.images.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  def create
    @image = @artwork.images.new(image_params)

    if @image.save
      redirect_to @artwork
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /images/1
  def update
    if @image.update(image_params)
      redirect_to @artwork
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # PATCH /images/1/move_image
  def move_image
    new_position = params[:to_index].to_i + 1
    @image.update position: new_position
    render json: {}, status: 200
  end

  # DELETE /images/1
  def destroy
    @image.destroy!
    redirect_to @artwork, status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_image
    @image = @artwork.images.find(params[:id])
  end

  def set_artwork
    @artwork = current_user.artworks.find(params[:artwork_id])
  end

  # Only allow a list of trusted parameters through.
  def image_params
    params.require(:image).permit(:caption, :file)
  end
end
