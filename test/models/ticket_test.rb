require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @user.confirm
    @ticket = @user.tickets.build(title: 'Lorem ipsum',
                                  content: 'Lorem ipsum dolor sit amet',
                                  price: 100,
                                  ticket_type: 'paper',
                                  location: 'Location')
    @ticket.category = categories(:one)
  end

  test 'should be vaild' do
    assert @ticket.valid?
  end

  test 'user should be present' do
    @ticket.user_id = nil
    assert_not @ticket.valid?
  end

  test 'title should be present' do
    @ticket.title = '    '
    assert_not @ticket.valid?
  end

  test 'title should be at most 70 characters' do
    @ticket.title = 'a' * 71
    assert_not @ticket.valid?
  end

  test 'content should be present' do
    @ticket.content = '     '
    assert_not @ticket.valid?
  end

  test 'content should be at most 4096 characters' do
    @ticket.content = 'a' * 4097
    assert_not @ticket.valid?
  end

  test 'price should be present' do
    @ticket.price = nil
    assert_not @ticket.valid?
  end

  test 'price should be greater or equal zero' do
    @ticket.price = -0.01
    assert_not @ticket.valid?
  end

  test 'ticket_type should be present' do
    @ticket.ticket_type = '     '
    assert_not @ticket.valid?
  end

  test 'location should not be too long' do
    @ticket.location = 'a' * 51
    assert_not @ticket.valid?
  end

  test 'location should not be blank' do
    @ticket.location = ' ' * 5
    assert_not @ticket.valid?
  end

  test 'ticket should belongs to subcategory' do
    @ticket.category = categories(:main_category)
    assert_not @ticket.valid?
  end
end
