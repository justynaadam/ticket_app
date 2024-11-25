require 'rails_helper'

feature 'User signup' do
  scenario 'valid signup information', js: true do
    Devise.mailer.deliveries.clear
    visit new_user_registration_path
    expect{
      fill_in 'Email', with: 'new@bar.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'
    }.to change(User, :count).by(1)
    expect(current_path).to eq root_path
    expect(Devise.mailer.deliveries.count).to eq 1
  end

  scenario 'invalid signup information', js: true do
    visit new_user_registration_path
    expect{
      fill_in 'Email', with: 'foo@bar.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'wrong_pass'
      click_button 'Sign up'
    }.not_to change(User, :count)
    expect(current_path).to eq user_registration_path
  end


end