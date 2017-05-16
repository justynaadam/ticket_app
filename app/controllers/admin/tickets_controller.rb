# frozen_string_literal: true

class Admin::TicketsController < Admin::AdminController
  helper_method :sort_column_tickets, :sort_direction
  def index
    @tickets = Ticket.order(sort_column_tickets + ' ' + sort_direction).paginate(page: params[:page])
  end

  def show
    @ticket = Ticket.find(params[:id])
    @next_ticket = @ticket.find_next(@ticket.updated_at, @ticket.category_id)
    @previous_ticket = @ticket.find_previous(@ticket.updated_at, @ticket.category_id)
  end

  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy
    flash[:success] = 'Announcement deleted'
    redirect_to admin_user_path(current_user)
  end
end
