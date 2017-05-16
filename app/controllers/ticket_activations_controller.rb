# frozen_string_literal: true

class TicketActivationsController < ApplicationController
  def edit
    ticket = Ticket.find(params[:t_id])
    if ticket && !ticket.activated? && ticket.authenticated?(params[:id])
      ticket.update_attributes(activated: true, activated_at: Time.zone.now)
      flash[:success] = 'Ticket activated!'
      redirect_to ticket
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_url
    end
  end
end
