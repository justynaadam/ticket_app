require 'rails_helper'

describe CategoriesController do
  describe 'GET #index' do
  	before(:each) { @category = create(:category) }
  	it 'populates an array of all categories' do
  	  get :index
  	  expect(assigns(:categories)).to match_array [@category]
  	end
  	it 'renders the index template' do
  	  get :index
      expect(response).to render_template :index
    end
  end
end