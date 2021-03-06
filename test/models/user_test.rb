# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email: 'user@foobar.com', password: 'foobar')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'email should be present' do
    @user.email = ' ' * 6
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@foobar.com'
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@foobar.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'password should be present (nonblank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'name should not be blank' do
    @user.name = ' ' * 5
    assert_not @user.valid?
  end

  test 'phone should not be too long' do
    @user.phone = ('9' * 16).to_i
    assert_not @user.valid?
  end

  test 'associated tickets should be destroyed' do
    @user.save
    ticket = @user.tickets.build(title: 'Lorem ipsum',
                                 content: 'Lorem ipsum dolor sit amet',
                                 price: 100,
                                 ticket_type: 'paper',
                                 location: 'location')
    ticket.category = categories(:one)
    ticket.save
    assert_difference 'Ticket.count', -1 do
      @user.destroy
    end
  end

  test 'should follow and unfollow ticket' do
    user = users(:one)
    ticket = tickets(:other_user_ticket)
    assert_not user.following?(ticket)
    user.follow(ticket)
    assert user.following?(ticket)
    assert ticket.followers.include?(user)
    user.unfollow(ticket)
    assert_not user.following?(ticket)
  end

  test 'associated searches should be destroyed' do
    @user.save
    search = @user.searches.build(keywords: 'Lorem ipsum')
    search.save
    assert_difference 'Search.count', -1 do
      @user.destroy
    end
  end
end
