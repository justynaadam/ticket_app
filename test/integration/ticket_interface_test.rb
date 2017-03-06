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
    # Valid ticket

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
    follow_redirect!
    assert_template 'tickets/show'
    assert_match title, response.body
    assert_match content, response.body
    assert assigns(:ticket).picture?
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

  test 'link to next ticket' do
    get ticket_path(tickets(:one))
    #tickets(:one).find_next
  end
end