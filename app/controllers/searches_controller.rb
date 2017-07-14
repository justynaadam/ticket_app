# frozen_string_literal: true

class SearchesController < ApplicationController
  helper_method :sort_column_tickets, :sort_direction
  before_action :authenticate_user!, only: %i[update destroy]
  before_action :get_search_or_redirect, only: %i[show new_tickets update destroy]

  def new
    @search = Search.new
  end

  def show
    @searched_user = if @search.searched_user.present?
                       User.find(@search.searched_user)
                     end
    @tickets = @search.tickets.order(sort_column_tickets + ' ' + sort_direction).paginate(page: params[:page])
    if @tickets.empty?
      flash.now[:info] = 'We did not find tickets for the query. Verify or try a more general query.'
    end
  end

  def new_tickets
    @tickets = @search.new_tickets.order(sort_column_tickets + ' ' + sort_direction).paginate(page: params[:page])
    @search.update_time
    render 'show'
  end

  def create
    @search = Search.create(search_params)
    redirect_to @search
  end

  def update
    @search.update_attribute(:user_id, current_user.id)
    @search.update_time
    respond_to do |format|
      format.html do
        flash[:success] = 'Search saved'
        redirect_to @search
      end
      format.js
    end
  end

  def destroy
    if current_user.searches.include?(@search)
      @search.destroy
      respond_to do |format|
        format.html { redirect_to searches_user_path(current_user) }
        format.js
      end
    else
      redirect_to root_path
    end
  end

  private

  def search_params
    params.require(:search).permit(:keywords, :location_keywords, :category_id, :minimum_price,
                                   :maximum_price, :in_content, :with_picture, :type_of_ticket, :searched_user)
  end

  def get_search_or_redirect
    @search = Search.find_by_id(params[:id])
    redirect_to root_url unless @search
  end
end
