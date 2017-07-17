require 'rails_helper'

feature 'Ticket intefrace' do
  let(:user) { create(:user) }
  before(:each) do
    user.confirm 
    login_as(user, scope: :user)
    create_sample_categories
  end
  scenario 'invalid create information', js: true do
    visit new_ticket_path
    invalid_attr = create_ticket_attributes
    fillin_ticket_form(invalid_attr)
    expect{click_button('Add ticket')}.not_to change(Ticket, :count)
  end
  scenario 'valid create information with activation', js: true do
    visit new_ticket_path
    valid_attr = create_ticket_attributes('valid')
    fillin_ticket_form(valid_attr)
    attach_file 'Picture', "#{Rails.root.join('app','assets','images','rails.png')}"
    expect{click_button('Add ticket')}.to change(Ticket, :count).by(1)
    expect(page).to have_content('Please check your mail to activate your ticket.')
    expect(current_path).to eq root_path
    ticket = Ticket.last
    token = ActionMailer::Base.deliveries.last.body.encoded.split.select { |part| part if part.starts_with?("http://") }[0].split('/')[4]

    # try to show ticket before activation
    visit ticket_path(ticket)
    expect(current_path).to eq(root_path)

    # does not show non-activ ticket on user page
    visit user_path(user)
    expect(page).to have_content('This ticket is non active')

    # Invalid activation token
    visit edit_ticket_activation_path('invalid token', t_id: ticket.id)
    expect(ticket).not_to be_activated

    # Valid activation token
    visit edit_ticket_activation_path(token, t_id: ticket.id)
    expect(ticket.reload).to be_activated
    expect(current_path).to eq ticket_path(ticket)
  end

  scenario 'delete ticket', js: true do
    ticket = create(:ticket, user_id: user.id)
    visit user_path(user)
    expect(page).to have_link('delete')
    expect{ click_link('delete') }.to change(Ticket, :count).by(-1)
  end

  scenario 'different user index page', js: true do
    other_user = create(:other_user)
    activated = create(:other_user_ticket, user_id: other_user.id)
    non_activated = create(:other_user_ticket, title: 'na', activated: false,  user_id: other_user.id)
    visit user_path(other_user)
    # no delete links
    expect(page).not_to have_link('delete')
    # does not show not activ ticket
    expect(page).not_to have_content(non_activated.title)
  end
end
