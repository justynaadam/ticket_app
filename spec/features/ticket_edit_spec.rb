require 'rails_helper'

feature 'Ticket edit' do
  let(:user) { create(:user) }
  let(:ticket) { create(:ticket, user_id: user.id) }

  before(:each) do
    user.confirm 
    login_as(user, scpoe: :user)
    create_sample_categories
  end
  
  scenario 'valid edit information', js: true do
    visit edit_ticket_path(ticket)
    valid_attr = {
      title: Faker::Lorem.characters(20),
      content: Faker::Lorem.sentence,
      price: 200,
      ticket_type: 'eTicket',
      location: Faker::GameOfThrones.city,
      category: Category.all.find(4).text,
      name: Faker::Name.name, 
      phone: Faker::PhoneNumber.subscriber_number(9).to_i
    }
    
    fillin_edit_ticket_form(valid_attr)
    attach_file 'Picture', "#{Rails.root}/app/assets/images/rails.png"
    click_button('Update')
    expect(page).to have_content('Announcement updated')
    expect(current_path).to eq ticket_path(ticket)

    ticket.reload
    user.reload
    expect(ticket.title).to eq valid_attr[:title]
    expect(ticket.content).to eq valid_attr[:content]
    expect(ticket.ticket_type).to eq valid_attr[:ticket_type]
    expect(ticket.price).to eq valid_attr[:price]
    expect(ticket.location).to eq valid_attr[:location]
    expect(ticket.category.text).to eq valid_attr[:category]
    expect(user.name).to eq valid_attr[:name]
    expect(user.phone).to eq valid_attr[:phone]
    expect(current_path).to eq ticket_path(ticket)
    expect(ticket.picture.model[:picture]).to eq 'rails.png'
  end
  
  scenario 'invalid edit information', js: true do
    visit edit_ticket_path(ticket)
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
    click_button('Update')
    ticket.reload
    user.reload
    expect(ticket.title).not_to eq invalid_attr[:title]
    expect(ticket.content).not_to eq invalid_attr[:content]
    expect(ticket.ticket_type).not_to eq invalid_attr[:ticket_type]
    expect(ticket.price).not_to eq invalid_attr[:price]
    expect(ticket.location).not_to eq invalid_attr[:location]
    expect(ticket.category.text).not_to eq invalid_attr[:category] 
  end
    
  scenario 'with ticket not belonging to user', js: true do
    other_user_ticket = create(:other_user_ticket)
    visit edit_ticket_path(other_user_ticket)
    expect(current_path).to eq root_path
  end
end