# frozen_string_literal: true

class TicketMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.ticket_mailer.ticket_activation.subject
  #
  def ticket_activation(ticket)
    @ticket = ticket
    mail to: ticket.user.email, subcject: 'Ticket activation'
  end
end
