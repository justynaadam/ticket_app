require 'test_helper'

class UserUpdateTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

 def setup
   @user = users(:one)
 end

 test 'successful edit' do
   sign_in users(:one)
   get edit_user_path(@user)
   assert_template 'users/edit'
   name = 'a' * 5
   location = 'a' * 5
   phone = 123
   patch user_path(@user), params: { user: { name: name, location: location, phone: phone } }
   assert_not flash.nil?
   assert_redirected_to edit_user_path(@user)
   # delete information
   name = ''
   location = ''
   phone = ''
   patch user_path(@user), params: { user: { name: name, location: location, phone: phone } }
   assert_not flash.nil?
   assert_redirected_to edit_user_path(@user)
   assert @user.name == nil
 end

 test 'unsuccessful edit' do
   sign_in @user
   get edit_user_path(@user)
   assert_template 'users/edit'
   assert @user.name.nil?
   name = ' ' * 5
   location = ' ' * 5
   phone = 'aaa'
   # Invalid name
   patch user_path(@user), params: { user: { name: name } }
   assert_redirected_to edit_user_path(@user)
   follow_redirect!
   assert_not @user.name == name
   # Invalid location
   patch user_path(@user), params: { user: { location: location } }
   assert_redirected_to edit_user_path(@user)
   assert_not @user.location == location
   # Invalid phone
   patch user_path(@user), params: { user: { phone: phone } }
   assert_redirected_to edit_user_path(@user)
   assert_not @user.phone == phone
 end
end
