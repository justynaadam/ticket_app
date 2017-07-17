require 'rails_helper'

feature 'User update' do
  let(:user) { create(:user) }
  before(:each) do
    user.confirm 
    login_as(user, scope: :user)
  end
  scenario 'valid update information', js: true do
    @name =  Faker::Name.name 
    @phone = Faker::PhoneNumber.subscriber_number(9).to_i
    visit edit_user_path(user)
    fill_in 'Name', with: @name
    fill_in 'Phone', with: @phone
    find_button(id: "change-contact-details").click
    expect(user.reload.name).to eq(@name)
    expect(user.reload.phone).to eq(@phone)
    expect(current_path).to eq edit_user_path(user)
    expect(page).to have_content('Profile updated')
  end
  
  scenario 'invalid update information', js: true do
    @name =  ' '
    @phone = ' '
    visit edit_user_path(user)
    fill_in 'Name', with: @name
    fill_in 'Phone', with: @phone
    find_button(id: "change-contact-details").click
    expect(user.reload.name).not_to eq(@name)
    expect(user.reload.phone).not_to eq(@phone)
    expect(current_path).to eq edit_user_path(user)
  end
end