require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:artist)
    sign_in @user
    @profile = @user.profile
  end

  test "should show profile" do
    get profile_url(@profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_profile_url(@profile)
    assert_response :success
  end

  test "should update profile when bio and avatar are in params" do
    avatar = fixture_file_upload("sabzian.jpeg", "image/jpeg")
    patch profile_url(@profile), params: {profile: {bio: @profile.bio, avatar: avatar, disciplines: @profile.disciplines, social_1: @profile.social_1, social_2: @profile.social_2, website: @profile.website}}
    assert_redirected_to profile_url(@profile)
  end

  test "admins can edit someone else's profile" do
    admin_user = users(:admin)
    sign_in admin_user
    get edit_profile_url(@profile)
    assert_response :success
  end
end
