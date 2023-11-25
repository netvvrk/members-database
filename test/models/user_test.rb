require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "a@a.com", password: "password1", password_confirmation: "password1", first_name: "An", last_name: "Artist")
  end

  test "defaults to active" do
    assert_equal true, @user.active
  end

  test "defaults to artist role" do
    assert_equal "artist", @user.role
  end

  test "has a name method" do
    assert_equal "An Artist", @user.name
  end
end
