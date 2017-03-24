class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(_users)
    admin_root_path
  end

  def sort_column_users
    User.column_names.include?(params[:sort]) ? params[:sort] : 'id'
  end

  def sort_column_tickets
    Ticket.column_names.include?(params[:sort]) ? params[:sort] : 'activated_at'
  end

  def sort_column_searches
    Search.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_column_relationships
    Relationship.column_names.include?(params[:sort]) ? params[:sort] : 'id'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'desc'
  end
end
