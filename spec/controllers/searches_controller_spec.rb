require 'rails_helper'

describe SearchesController do
  describe 'GET #new' do
    it 'assings a new Search to @search' do
      get :new
      expect(assigns(:search)).to be_a_new(Search)
    end
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end
  describe 'GET #show' do
    before(:each) { @search = Search.create() }
    it 'assings the requested search to @search' do
      get :show, params: { id: @search }
      expect(assigns(:search)).to eq @search
    end
    it 'redners the :show template' do
      get :show, params: { id: @search }
      expect(response).to render_template :show
    end 
  end 
  
end