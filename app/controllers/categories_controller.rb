class CategoriesController < ApplicationController
  
  def index
    @categories = Category.where(main_id: nil).all
  end
  
  def show
    @category = Category.find(params[:id])
    @tickets = @category.tickets.paginate(page: params[:page])
  end

end
