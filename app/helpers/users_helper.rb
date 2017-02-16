module UsersHelper

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def after_update(message)
    flash[:success] = message
    redirect_to edit_user_path(@user)
  end
end
