require 'rails_helper'

describe UsersController do
  let(:user) { create(:user) }

  describe 'PATCH #update' do
  	it 'does not allow admin attribute to be edited via web' do
  	  sign_in user
  	  user.confirm
  	  expect(user).not_to be_admin
  	  patch :update, params: { id: user, user: attributes_for(:user, admin: true) }
  	  user.reload
  	  expect(user).not_to be_admin
  	end
  end
  
  describe 'following' do
    it 'redirects following when not logged in' do
      get :following, params: { id: user }
      expect(response).to redirect_to root_path
    end
  end
end