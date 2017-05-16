# frozen_string_literal: true

class Admin::SearchesController < Admin::AdminController
  helper_method :sort_column_searches, :sort_direction, :sort_column_tickets

  def index
    @searches = Search.order(sort_column_searches + ' ' + sort_direction).paginate(page: params[:page])
  end

  def show
    @search = Search.find(params[:id])
    @searched_user = if @search.searched_user.present?
                       User.find(@search.searched_user)
                     end
    @tickets = @search.tickets.order(sort_column_tickets + ' ' + sort_direction).paginate(page: params[:page])
    if @tickets.empty?
      flash.now[:info] = 'We did not find tickets for the query. Verify or try a more general query.'
    end
  end

  def new_tickets
    @search = Search.find(params[:id])
    @tickets = @search.new_tickets.order(sort_column_tickets + ' ' + sort_direction).paginate(page: params[:page])
    render 'show'
  end

  def destroy
    @search = Search.find(params[:id])
    @search.destroy
    redirect_to admin_searches_path
  end
end
