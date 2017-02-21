require 'test_helper'

class AdminUsersIndexTestTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:admin)
    @admin.confirm
  end

  test "index including pagination" do
    sign_in @admin
    get admin_users_path
    assert_template 'admin/users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', admin_user_path(user), text: user.email
      assert_select 'a[href=?]', admin_user_path(user), text: 'delete'
    end
  end
end
