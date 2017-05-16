# frozen_string_literal: true

require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @admin.confirm
    @user = users(:one)
    @user.confirm
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete admin_user_path(@user)
    end
    assert_redirected_to root_path
  end

  test 'should redirect destroy when logged in as non-admin' do
    sign_in @user
    assert_no_difference 'User.count' do
      delete admin_user_path(@admin)
    end
    assert_redirected_to root_path
  end

  test 'should destroy when logged in as admin' do
    sign_in @admin
    assert_difference 'User.count', -1 do
      delete admin_user_path(@user)
    end
    assert_redirected_to admin_users_path
    follow_redirect!
    assert_not flash.empty?
  end
end
