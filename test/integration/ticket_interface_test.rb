# frozen_string_literal: true

require 'test_helper'

class TicketInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
    @user.confirm
    ActionMailer::Base.deliveries.clear
  end

  test 'ticket interface' do
    get new_ticket_path
    assert_template 'tickets/new'
    assert_select 'input[type=file]'
    # Invalid ticket
    assert_no_difference 'Ticket.count' do
      post tickets_path, params: { ticket: { title: '',
                                             content: '',
                                             ticket_type: '',
                                             price: '',
                                             location: '',
                                             category_id: '',
                                             user_attributes: { name: '',
                                                                phone: '' } } }
    end
  end

  test 'valid ticket with ticket activation' do
    get new_ticket_path
    title = 'title'
    content = 'content'
    ticket_type = 'ticket_type'
    price = 123
    location = 'location'
    name = 'name'
    phone = 9999
    picture = fixture_file_upload('test/fixtures/image.png', 'image/png')
    assert_difference 'Ticket.count', 1 do
      category = categories(:subcategory_2)
      post tickets_path, params: { ticket: { title: title,
                                             content: content,
                                             ticket_type: ticket_type,
                                             price: price,
                                             location: location,
                                             category_id: category.id,
                                             picture: picture,
                                             user_attributes: { name: name,
                                                                phone: phone } } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    ticket = assigns(:ticket)
    assert_not ticket.activated?

    # try to show ticket before activation
    get ticket_path(ticket)
    assert_redirected_to root_url

    # Invalid activation token
    get edit_ticket_activation_path('invalid token', t_id: ticket.id)
    assert_not ticket.activated?

    # Valid activation token
    get edit_ticket_activation_path(ticket.activation_token, t_id: ticket.id)
    assert ticket.reload.activated?
    follow_redirect!
    assert_template 'tickets/show'
  end

  test 'delete ticket' do
    get user_path(@user)
    assert_select 'a', text: 'delete'
    first_ticket = @user.tickets.paginate(page: 1).first
    assert_difference 'Ticket.count', -1 do
      delete ticket_path(first_ticket)
    end
    # Visit different user (no delete links)
    get user_path(users(:two))
    assert_select 'a', text: 'delete', count: 0
  end

  test 'should show not activ ticket on user index page' do
    get user_path(@user)
    ticket = tickets(:non_activated)
    assert_match ticket.title, response.body
  end

  test 'should not show not activ ticket on different user index page' do
    sign_in users(:two)
    users(:two).confirm
    get user_path(@user)
    ticket = tickets(:non_activated)
    assert_no_match ticket.title, response.body
  end
end
