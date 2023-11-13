class ImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_artwork
  before_action :set_image, only: %i[show edit update destroy]

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
      redirect_to artwork_images_url(@artwork), notice: "Image was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
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
