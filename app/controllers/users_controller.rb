class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :confirm_admin
  before_action :set_user, only: %i[show edit update login_as send_welcome_email]

  # GET /users
  def index
    @page = params[:page]&.to_i || 0
    @search_term = params[:search]
    @users = User.includes(:profile).order(id: :desc).page(@page)

    if @search_term
      @users = @users.search(@search_term).with_pg_search_rank
    end
  end

  # GET /users/1
  def show
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # def create
  #   @user = User.new(user_params)

  #   if @user.save
  #     redirect_to @user, notice: "User was successfully created."
  #   else
  #     render :new, status: :unprocessable_entity
  #   end
  # end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "User was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # def destroy
  #   @user.destroy!
  #   redirect_to users_url, notice: "User was successfully destroyed.", status: :see_other
  # end

  def login_as
    bypass_sign_in(@user)
    redirect_to root_path, notice: "Now logged in as #{@user.profile.name}"
  end

  def send_welcome_email
    @user.update!(active: true) unless @user.active
    @user.send_welcome_email
    redirect_to users_path, notice: "Welcome email sent to #{@user.email}"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def confirm_admin
    unless current_user.admin?
      redirect_to root_url, notice: "You do not have access to that page"
    end
  end
end
