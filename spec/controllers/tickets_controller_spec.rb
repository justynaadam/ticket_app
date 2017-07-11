require 'rails_helper'

describe TicketsController do
	shared_examples_for 'public access to tickets' do
		 before :each do
		   @ticket = create(:ticket)
		 end
	
		describe 'GET #index' do
	      it 'populates an array of all tickets' do
		    get :index
			expect(assigns(:tickets)).to match_array [@ticket]
		  end
		  it 'renders the :index template' do
			get :index
			expect(response).to render_template :index
		  end
		end
		
		describe  'GET #show' do
		  it 'assings the requested ticket to @ticket' do
			get :show, params: { id: @ticket.id }
			expect(assigns(:ticket)).to eq @ticket
		  end
		  it 'render the show template' do
			get :show, params: { id: @ticket.id }
			expect(response).to render_template :show
		  end
		end
	end

	describe 'guest access' do
      it_behaves_like 'public access to tickets'
      describe 'GET #new' do
      	it 'requires login' do
          get :new
          expect(response).to redirect_to new_user_session_path
        end
      end
      describe 'GET #edit' do
      	it 'requires login' do
      	  ticket = create(:ticket)
          get :edit, params: { id: ticket }
          expect(response).to redirect_to new_user_session_path
        end
      end
      describe 'POST #create' do
        it 'requires login' do
          post :create, params: { id: create(:ticket), ticket: attributes_for(:ticket) }
          expect(response).to redirect_to new_user_session_path
        end
      end
       
      describe 'PATCH #update' do
        it 'requires login' do
          put :update, params: { id: create(:ticket), ticket: attributes_for(:ticket) }
          expect(response).to redirect_to new_user_session_path
        end
      end

      describe 'DELETE #destroy' do
        it 'requires login' do
          delete :destroy, params: { id: create(:ticket) }
          expect(response).to redirect_to new_user_session_path
        end
      end
    end

    describe 'user access' do
      before(:each) do
      	@user = create(:user, email: 'foo@bar11.co')
        sign_in @user
        @user.confirm
      end
      it_behaves_like 'public access to tickets'
      describe 'GET #new' do
		it 'assings a new Ticket to @ticket' do
		  get :new
		  expect(assigns(:ticket)).to be_a_new(Ticket)
		end
		it 'renders the :new template' do
	      get :new
	      expect(response).to render_template :new
	    end
	  end

	  describe 'GET #edit' do
	  	before(:each) {  @ticket = create(:ticket, user_id: @user.id) }
		it 'assings the requested ticket to @ticket' do
		  get :edit, params: { id: @ticket.id }
		  expect(assigns(:ticket)).to eq @ticket
		end
		it 'renders the :edit template' do
	      get :edit, params: { id: @ticket.id }
	      expect(response).to render_template :edit
	    end

	  end

	 #  describe 'POST #create' do
	 #  	before(:each) do
	 #  	  @tickets = params: { ticket: { title: title,
  #                                        content: content,
  #                                        ticket_type: ticket_type,
  #                                        price: price,
  #                                        location: location,
  #                                        category_id: category.id,
  #                                        user_attributes: { name: name,
  #                                                           phone: phone } }
	 #  	end
		# context 'with valid attributes' do
		# 	it 'saves the new ticket in the database' do
		# 	  expect{ 
		# 	  	post :create, params: { ticket: attributes_for(:ticket, tickets_attributes: @tickets) }
		# 	  }.to change(Ticket, :count).by(1)
		# 	end
		# 	it 'redirects to tickets#show'
		# end
		# context 'with invalid attributes' do
		# 	it 'does not save the ticket in database'
		# 	it 're-renders the :new template'
		# end
	 #  end

	 #  describe 'PATCH #update' do
		# context 'with valid attributes' do
  #         it 'updates the ticket in the database'
  #         it 'redirects to the ticket'
  #       end

  #       context 'with invalid attributes' do
  #       	it 'does not update the ticket'
  #       	it 're-renders the :edit template'
  #       end
  #     end

      describe 'DELETE #destroy' do
      	context 'with ticket belonging to user' do 
		  before(:each) {  @ticket = create(:ticket, user_id: @user.id) }
		  it 'deletes the ticket from the database' do
			expect{ delete :destroy, params: { id: @ticket.id } }.to change(Ticket, :count).by(-1)
		  end
		  it 'redirects to users#show' do
			delete :destroy, params: { id: @ticket.id }
			expect(response).to redirect_to user_path(@user)
		  end
		end
		context 'with ticket not belonging to user' do
		  before(:each) {  @ticket = create(:ticket) }
		  it 'does not delete the ticket in database' do
		    expect{ delete :destroy, params: { id: @ticket.id } }.not_to change(Ticket, :count)
		  end
		  it 'redirects to root path' do
		  	delete :destroy, params: { id: @ticket.id }
		  	expect(response).to redirect_to root_url
		  end
		end
      end
    end

end
