# Preview all emails at https://ticket-market-somethingtimeless.c9users.io/rails/mailers
class TicketMailerPreview < ActionMailer::Preview
  # Preview this email at https://ticket-market-somethingtimeless.c9users.io/rails/mailers/ticket_mailer/ticket_activation
  def ticket_activation
    ticket = Ticket.first
    ticket.activation_token = Ticket.new_token
    TicketMailer.ticket_activation(ticket)
  end
end
