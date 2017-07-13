require 'rails_helper'

feature 'User signup' do
  scenario 'valid signup information' do
    visit new_user_registration_path
    expect{
      fill_in 'Email', with: 'foo@bar.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'
    }.to change(User, :count).by(1)
    expect(current_path).to eq root_path
  end

  scenario 'invalid signup information' do
    visit new_user_registration_path
    expect{
      fill_in 'Email', with: 'foo@bar.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'wrong_pass'
      click_button 'Sign up'
    }.not_to change(User, :count)
    #expect(page).to have_template new_user_registration_path
  end


end