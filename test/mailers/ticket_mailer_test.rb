require 'test_helper'

class TicketMailerTest < ActionMailer::TestCase
  test 'ticket_activation' do
    ticket = tickets(:one)
    ticket.activation_token = Ticket.new_token
    mail = TicketMailer.ticket_activation(ticket)
    assert_equal 'Ticket activation', mail.subject
    assert_equal [ticket.user.email], mail.to
    assert_equal ['noreply@example.com'], mail.from
    assert_match ticket.user.name, mail.body.encoded
    assert_match ticket.activation_token, mail.body.encoded
    assert_match ticket.id.to_s, mail.body.encoded
  end
end
