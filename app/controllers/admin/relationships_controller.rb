# frozen_string_literal: true

class Admin::RelationshipsController < Admin::AdminController
  helper_method :sort_column_relationships, :sort_direction

  def index
    @relationships = Relationship.order(sort_column_relationships + ' ' + sort_direction).paginate(page: params[:page])
  end

  def destroy
    @relationship = Relationship.find(params[:id])
    @relationship.destroy
    flash[:success] = 'Relationship destroyed'
    redirect_back(fallback_location: root_path)
  end
end
