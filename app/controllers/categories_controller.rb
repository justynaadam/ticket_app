# frozen_string_literal: true

class CategoriesController < ApplicationController
  helper_method :sort_column_tickets, :sort_direction

  def index
    @categories = Category.where(main_id: nil).all
    @tickets = Ticket.activated.order(activated_at: :desc).limit(15)
  end

  def show
    @pre_select = params[:id]
    @category = Category.find(params[:id])
    if @category.main?
      @tickets = Ticket.activated.where(category: @category.subcategories).order(sort_column_tickets + ' ' + sort_direction).paginate(page: params[:page])
    else
      @tickets = Ticket.activated.where(category: @category).order(sort_column_tickets + ' ' + sort_direction).paginate(page: params[:page])
    end
  end
end
