require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:artist)
    sign_in @user
    @profile = profiles(:one)
    @profile.user = @user
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
    avatar = fixture_file_upload('sabzian.jpeg', 'image/jpeg')
    patch profile_url(@profile), params: { profile: { bio: @profile.bio, avatar: avatar, disciplines: @profile.disciplines, social_1: @profile.social_1, social_2: @profile.social_2, website: @profile.website } }
    assert_redirected_to profile_url(@profile)
  end

  test "should update profile when bio is in params and profile already has avatar" do
    @profile.avatar.new
    patch profile_url(@profile), params: { profile: { bio: @profile.bio, disciplines: @profile.disciplines, social_1: @profile.social_1, social_2: @profile.social_2, website: @profile.website } }
    assert_redirected_to profile_url(@profile)
  end

  test "should fail when bio is missing in params" do
    avatar = fixture_file_upload('sabzian.jpeg', 'image/jpeg')
    patch profile_url(@profile), params: { profile: { disciplines: @profile.disciplines, avatar: avatar, social_1: @profile.social_1, social_2: @profile.social_2, website: @profile.website } }
    assert_response 422
  end  

  test "should fail when avatar is neithr in profile nor params" do
    patch profile_url(@profile), params: { profile: { disciplines: @profile.disciplines, social_1: @profile.social_1, social_2: @profile.social_2, website: @profile.website } }
    assert_response 422
  end    

  test "non-admin users cannot edit someone else's profile" do
    another_user = users(:curator)
    sign_in another_user
    get edit_profile_url(@profile)
    assert_response :redirect
  end

  test "admins can edit someone else's profile" do
    admin_user = users(:admin)
    sign_in admin_user
    get edit_profile_url(@profile)
    assert_response :success
  end

end
