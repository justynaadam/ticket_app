class Admin::UsersController < Admin::AdminController
  include UsersHelper
  helper_method :sort_column_users, :sort_direction, :sort_column_tickets

  def index
    @users = User.order(sort_column_users + ' ' + sort_direction).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @tickets = @user.tickets.order(sort_column_tickets + ' ' + sort_direction).paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to admin_users_path
  end

  def following
    @user = User.find(params[:id])
    if @user.nil?
      redirect_to root_path
    else
      @tickets = @user.following.paginate(page: params[:page])
    end
  end

  def searches
    @user = User.find(params[:id])
    if @user.nil?
      redirect_to root_path
    else
      @user_searches = @user.searches.paginate(page: params[:page])
      render 'searches'
    end
  end
end
