class SearchesController < ApplicationController
  helper_method :sort_column, :sort_direction
  def new
    @search = Search.new
  end

  def show
    @search = Search.find(params[:id])
    unless @search.searched_user.present?
      @searched_user = nil
    else
      @searched_user = User.find(@search.searched_user)
    end
    @tickets = @search.tickets.order(sort_column + ' ' + sort_direction).paginate(page: params[:page])
    if @tickets.empty?
      flash.now[:info] = 'We did not find tickets for the query. Verify or try a more general query.'
    end
  end
  
  def create
    @search = Search.create(search_params)
    redirect_to @search
  end
  
  def destroy
    @search = Search.find(params[:id])
    @search.destroy
  end

  def search_params
    params.require(:search).permit(:keywords, :location_keywords, :category_id, :minimum_price,
                                   :maximum_price, :in_content, :with_picture, :type_of_ticket, :searched_user)
  end
end
