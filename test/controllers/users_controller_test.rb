s# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @user.confirm
  end

  test 'should not allow the admin attribute to be edited via the web' do
    sign_in @user
    assert_not @user.admin?
    patch user_path(@user), params: {
      user: { name:              'foobar',
              admin: true }
    }
    assert_not @user.reload.admin?
  end

  test 'should redirect following when not logged in' do
    get following_user_path(@user)
    assert_redirected_to root_path
  end
end
