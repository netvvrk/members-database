class ArtistsController < ApplicationController
  def show
    user = User.artist.is_active.find(params[:id])
    @profile = user.profile
  end
end
