class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @ticket = Ticket.find(params[:followed_id])
    current_user.follow(@ticket)
     respond_to do |format|
     format.html { (redirect_back(fallback_location: root_path)) }
     format.js
     end
  end

  def destroy
    @ticket = Relationship.find(params[:id]).followed
    current_user.unfollow(@ticket)
     respond_to do |format|
     format.html { (redirect_back(fallback_location: root_path)) }
     format.js
     end
  end

  def logged_in_user
    redirect_to new_user_session_path if current_user.nil?
  end
end
