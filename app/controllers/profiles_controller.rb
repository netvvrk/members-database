class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile
  before_action :confirm_edit_access, only: %i[edit update]
  before_action :confirm_profile_belongs_to_artist, only: %i[show edit update]

  # GET /profiles/1
  def show
  end

  # GET /profiles/1/edit
  def edit
  end

  # PATCH/PUT /profiles/1
  def update
    if @profile.update(profile_params)
      redirect_to @profile, notice: "Profile was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_profile
    @profile = Profile.find(params[:id])
  end

  # Only allow a list of trusted parameters through
  def profile_params
    params.require(:profile).permit(:bio, :name, :website, :social_1, :social_2, :disciplines, :avatar, :cv, tag_ids: [])
  end

  rescue_from ActionController::ParameterMissing do |e|
    flash[:error] = e.message
    render :edit, status: :unprocessable_entity
  end

  def confirm_edit_access
    unless current_user.admin? || current_user.id == @profile.user.id
      redirect_to root_url, notice: "You cannot edit this profile"
    end
  end

  def confirm_profile_belongs_to_artist
    unless @profile.user.artist?
      redirect_to root_url, notice: "Only artists have profiles"
    end
  end
end
