class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(users)
    admin_root_path
  end
  
  def sort_column
    Ticket.column_names.include?(params[:sort]) ? params[:sort] : 'activated_at'
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
end
