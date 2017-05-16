# frozen_string_literal: true

class Admin::AdminController < ApplicationController
  before_action :is_admin?

  def is_admin?
    redirect_to root_path unless current_user.try(:admin?)
  end
end
