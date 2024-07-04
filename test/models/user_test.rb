require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: "a@a.com", password: "password1", password_confirmation: "password1")
  end

  test "defaults to active" do
    assert_equal true, @user.active
  end

  test "defaults to artist role" do
    assert_equal "artist", @user.role
  end

  test "requires a last name upon update" do
    @user.update(email: "a@b.com")
    refute @user.valid?
    @user.update(last_name: "last-name")
    assert @user.valid?
  end
end
