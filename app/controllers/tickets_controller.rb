class TicketsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :update_contact, only: [:create, :update]

  def index
    @tickets = Ticket.paginate(page: params[:page])
  end

  def show
     @ticket = Ticket.find(params[:id])
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = current_user.tickets.build(ticket_params)
    if @ticket.save
      flash[:success] = "Announcement added!"
      redirect_to ticket_path(@ticket)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @ticket.update_attributes(ticket_params)
      flash[:success] = 'Announcement updated'
      redirect_to @ticket
    else
      render 'edit'
    end
  end

  def destroy
    @ticket.destroy
    flash[:success] = 'Announcement deleted'
    redirect_to user_path(current_user)
  end

  def update_contact
    @user = current_user
    @user.name = ticket_params[:user_attributes][:name]
    @user.phone = ticket_params[:user_attributes][:phone]
    @user.validate_name = true
    redirect_back(fallback_location: root_path) unless @user.save
  end
  
  private

      def ticket_params
        params.require(:ticket).permit(:title, :content, :price, :ticket_type, user_attributes: [:name, :phone])
      end
     
      def correct_user
        @ticket = current_user.tickets.find_by(id: params[:id])
        redirect_to root_url if @ticket.nil?
      end
end
