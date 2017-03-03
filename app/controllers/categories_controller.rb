class CategoriesController < ApplicationController
  
  def index
    @categories = Category.where(main_id: nil).all
    @tickets = Ticket.all.limit(15)
  end
  
  def show
    @category = Category.find(params[:id])
    if @category.main?
      @tickets = Ticket.where(category: @category.subcategories).paginate(page: params[:page])
    else
      @tickets = @category.tickets.paginate(page: params[:page])
    end
  end

end
