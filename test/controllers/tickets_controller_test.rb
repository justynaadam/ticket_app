require 'test_helper'

class TicketsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @ticket = tickets(:one)
    @other_ticket = tickets(:other_user_ticket)
  end

  test 'should redirect new when not logged in' do
    get new_ticket_path
    assert_redirected_to new_user_session_path
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Ticket.count' do
      post tickets_path, params: { ticket: { title: 'Lorem ipsum', 
                                            content: 'Lorem ipsum dolor sit amet',
                                            price: 100,
                                            ticket_type: 'paper' } }
      end
    assert_redirected_to new_user_session_path
  end

  test 'should redirect edit when not logged in' do
    get edit_ticket_path(@ticket)
    assert_redirected_to new_user_session_path
  end

  test 'should redirect update when not logged in' do
    new_title = 'New title'
    patch ticket_path(@ticket), params: { ticket: { title: new_title } }
    assert_redirected_to new_user_session_path
    assert_not_equal @ticket.reload.title, new_title
  end
  
  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Ticket.count' do
      delete ticket_path(@ticket)
    end
  end

  test 'should redirect destroy for wrong ticket' do
    sign_in users(:one)
    users(:one).confirm
    assert_no_difference 'Ticket.count' do
      delete ticket_path(@other_ticket)
    end
    assert_redirected_to root_path
  end
end
