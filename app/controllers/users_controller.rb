class UsersController < ApplicationController
  helper_method :sort_column_tickets, :sort_direction
  include UsersHelper

  def show
    @user = User.find(params[:id])
    @user_id = @user.id
    if @user == current_user
      @tickets = @user.tickets.order(sort_column_tickets + ' ' + sort_direction).paginate(page: params[:page])
    else
      @tickets = Ticket.activated.where(user_id: @user.id).order(sort_column_tickets + ' ' + sort_direction).paginate(page: params[:page])
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    params[:user][:name] = nil if params[:user][:name] == ''
    params[:user][:phone] = nil if params[:user][:phone] == ''

    if @user.update_attributes(user_params)
      after_update('Profile updated')
    else
      redirect_to edit_user_path(@user)
    end
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(user_password_params)
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user)
      after_update('Password updated')
    else
      redirect_to edit_user_path(@user)
    end
  end

  def update_email
    @user = User.find(current_user.id)
    if @user.update(user_email_params)
      after_update('Email updated')
    else
      redirect_to edit_user_path(@user)
    end
  end

  def following
    @user = current_user
    if @user.nil?
      redirect_to root_path
    else
      @tickets = @user.following.paginate(page: params[:page])
    end
  end

  def searches
    @user = current_user
    if @user.nil?
      redirect_to root_path
    else
      @user_searches = @user.searches.paginate(page: params[:page])
      render 'searches'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone)
  end

  def user_password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end

  def user_email_params
    params.require(:user).permit(:email)
  end
end
