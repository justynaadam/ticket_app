require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:two)
    sign_in @user
    @user.confirm
    @ticket = tickets(:two)
  end

  test 'following page' do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |ticket|
      assert_select 'a[href=?]', ticket_path(ticket)
    end
  end

  test 'should follow a ticket the standard way' do
    # assert_not @ticket.nil?
    assert_difference '@ticket.followers.count', 1 do
      post relationships_path, params: { followed_id: @ticket.id }
    end
  end

  test 'should follow a ticket with Ajax' do
    assert_not @ticket.nil?
    assert_difference '@ticket.followers.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @ticket.id }
    end
  end

  test 'should unfollow a user the standard way' do
    @user.follow(@ticket)
    relationship = @user.relationships.find_by(followed_id: @ticket.id)
    assert_difference '@ticket.followers.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test 'should unfollow a user with Ajax' do
    @user.follow(@ticket)
    relationship = @user.relationships.find_by(followed_id: @ticket.id)
    assert_difference '@ticket.followers.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
end
