require 'rails_helper'

feature 'Ticket intefrace' do
  let(:user) { create(:user) }
  #let(:ticket) { create(:ticket, user_id: user.id) }

  before(:each) do
    user.confirm 
    login_as(user, scpoe: :user)
  end
  scenario 'invalid create information' do
    visit new_ticket_path
    invalid_attr = {
      title: nil,
      content: nil,
      price: nil,
      ticket_type: 'eTicket',
      location: nil,
      category: Category.all.find(4).text,
      name: nil, 
      phone: nil
    }
    fillin_edit_ticket_form(invalid_attr)
    click_button('Add ticket')
    # assert_no_difference 'Ticket.count' do
    #   post tickets_path, params: { ticket: { title: '',
    #                                          content: '',
    #                                          ticket_type: '',
    #                                          price: '',
    #                                          location: '',
    #                                          category_id: '',
    #                                          user_attributes: { name: '',
    #                                                             phone: '' } } }
    # end
  end
end
