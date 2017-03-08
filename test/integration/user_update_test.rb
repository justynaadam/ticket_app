require 'test_helper'

class UserUpdateTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

 def setup
   @user = users(:one)
   @user.confirm
 end

 test 'successful edit' do
   sign_in users(:one)
   get edit_user_path(@user)
   assert_template 'users/edit'
   name = 'a' * 5
   phone = 123
   patch user_path(@user), params: { user: { name: name, phone: phone } }
   assert_not flash.nil?
   assert_redirected_to edit_user_path(@user)
   # delete information
   name = ''
   phone = ''
   patch user_path(@user), params: { user: { name: name, phone: phone } }
   assert_not flash.nil?
   assert_redirected_to edit_user_path(@user)
   @user.reload
   assert @user.name == nil
 end

 test 'unsuccessful edit' do
   sign_in @user
   get edit_user_path(@user)
   assert_template 'users/edit'
   name = ' ' * 5
   phone = 'aaa'
   # Invalid name
   patch user_path(@user), params: { user: { name: name } }
   assert_redirected_to edit_user_path(@user)
   follow_redirect!
   assert_not @user.name == name
   # Invalid phone
   patch user_path(@user), params: { user: { phone: phone } }
   assert_redirected_to edit_user_path(@user)
   assert_not @user.phone == phone
 end
end
