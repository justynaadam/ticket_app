class TicketsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :update_contact, only: [:create, :update]

  def index
    @tickets = Ticket.where(activated: true).paginate(page: params[:page])
  end

  def show
    @ticket = Ticket.find(params[:id])
    @next_ticket = @ticket.find_next(@ticket.updated_at, @ticket.category_id)
    @previous_ticket = @ticket.find_previous(@ticket.updated_at, @ticket.category_id)
    redirect_to(root_url) && return unless @ticket.activated?
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = current_user.tickets.build(ticket_params)
    if @ticket.save
      @ticket.send_activation_email
      flash[:info] = 'Please check your mail to activate your ticket.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit; end

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
    params.require(:ticket).permit(:title, :content, :price, :ticket_type, :location, :category_id, :picture, user_attributes: [:name, :phone])
  end

  def correct_user
    @ticket = current_user.tickets.find_by(id: params[:id])
    redirect_to root_url if @ticket.nil?
  end
end
