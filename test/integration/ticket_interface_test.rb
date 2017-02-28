require 'test_helper'

class TicketInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    sign_in @user
    @user.confirm
  end
  
  test 'ticket interface' do

    get new_ticket_path
    assert_template 'tickets/new'
    # Invalid ticket
    assert_no_difference 'Ticket.count' do
    post tickets_path, params: { ticket: { title: '',
                                           content: '',
                                           ticket_type: '',
                                           price: '',
                                           location: '',
                                           user_attributes: { name: '',
                                                              phone: '' } } }
    end
    # Valid ticket
    get new_ticket_path
    title = 'title'
    content = 'content'
    ticket_type = 'ticket_type'
    price = 123
    location = 'location'
    name = 'name'
    phone = 9999
    assert_difference 'Ticket.count', 1 do
    post tickets_path, params: { ticket: { title: title,
                                          content: content,
                                          ticket_type: ticket_type,
                                          price: price,
                                          location: location,
                                          user_attributes: { name: name,
                                                              phone: phone } } }
    end
    follow_redirect!
    assert_template 'tickets/show'
    assert_match title, response.body
    assert_match content, response.body
    # Delete ticket
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
end
