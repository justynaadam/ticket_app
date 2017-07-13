require 'rails_helper'

describe RelationshipsController do
  describe 'guest access' do
    describe 'POST #create' do
      it 'requires login' do
        post :create
        expect(response).to redirect_to new_user_session_path
      end
    end
    describe 'DELETE #destroy' do
      it 'requires login' do
        relationship = create(:relationship)
        delete :destroy, params: { id: relationship }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
