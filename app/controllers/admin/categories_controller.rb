# frozen_string_literal: true

class Admin::CategoriesController < Admin::AdminController
  helper_method :sort_column_tickets, :sort_direction

  def index
    @categories = Category.where(main_id: nil).all
    @tickets = Ticket.order(activated_at: :desc).paginate(page: params[:page])
  end

  def show
    @pre_select = params[:id]
    @category = Category.find(params[:id])
    if @category.main?
      @tickets = Ticket.where(category: @category.subcategories).order(sort_column_tickets + ' ' + sort_direction).paginate(page: params[:page])
    else
      @tickets = Ticket.where(category: @category).order(sort_column_tickets + ' ' + sort_direction).paginate(page: params[:page])
    end
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(categories_params)
    if @category.save
      flash[:success] = 'New category created!'
      redirect_to admin_categories_path
    else
      render 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(categories_params)
      flash[:success] = 'Category updated'
      redirect_to admin_categories_path
    else
      render 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:success] = 'Category deleted'
    redirect_to admin_categories_path
  end

  private

  def categories_params
    params.require(:category).permit(:text, :main_id)
  end
end
