require 'rails_helper'

describe StaticPagesController do
  render_views
  let(:base_title) { 'Ticket Market' }
  describe 'home' do
    it 'render the home template' do
      get :home
      expect(response).to render_template :home
    end
    it 'title should be proper' do
      get :home
      assert_select 'title', "Home | #{base_title}"
    end
  end
  describe 'help' do
    it 'render the help template' do
      get :help
      expect(response).to render_template :help
    end
    it 'titile should be proper' do
      get :help
      assert_select 'title', "Help | #{base_title}"
    end
  end
end