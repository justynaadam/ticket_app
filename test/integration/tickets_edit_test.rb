require 'test_helper'

class TicketsEditTest < ActionDispatch::IntegrationTest

  def setup
    @ticket = tickets(:one)
    @user = users(:one)
    @other_user = users(:two)
  end
  
  test 'unsuccessful edit' do
    sign_in @user
    @user.confirm
    get edit_ticket_path(@ticket)
    assert_template 'tickets/edit'
    patch ticket_path(@ticket), params: { ticket: { title: '',
                                                    content: '',
                                                    ticket_type: ' ',
                                                    price: '',
                                                    location: '',
                                                    user_attributes: { name: '',
                                                                       phone: '' } } }
    assert_redirected_to root_url
  end

  test 'successful edit' do
    sign_in @user
    @user.confirm
    get edit_ticket_path(@ticket)
    assert_template 'tickets/edit'
    title = 'updated title'
    content = 'updated content'
    ticket_type = 'updated type'
    price = 999
    location = 'location'
    name = 'name'
    phone = 9999
    patch ticket_path(@ticket), params: { ticket: { title: title,
                                                    content: content,
                                                    ticket_type: ticket_type,
                                                    price: price,
                                                    location: location,
                                                    category_id: 3,
                                                    user_attributes: { name: name,
                                                                       phone: phone } } }
    assert_not flash.empty?
    assert_redirected_to @ticket
    @ticket.reload
    @user.reload
    assert_equal title, @ticket.title
    assert_equal content, @ticket.content
    assert_equal ticket_type, @ticket.ticket_type
    assert_equal price, @ticket.price
    assert_equal location, @ticket.location
    assert_equal name, @user.name
    assert_equal phone, @user.phone
  end

  test 'should redirect edit when logged in as wrong user' do
    sign_in @other_user
    @other_user.confirm
    get edit_ticket_path(@ticket)
    assert_redirected_to root_url
  end
end
