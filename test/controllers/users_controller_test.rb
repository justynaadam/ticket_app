require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
def setup
  @user = users(:one)
  @user.confirm
end
  
  test "should not allow the admin attribute to be edited via the web" do
    sign_in @user
    assert_not @user.admin?
    patch user_path(@user), params: {
                              user: { name:              'foobar',
                                      admin: true } }
    assert_not @user.reload.admin?
  end
end
