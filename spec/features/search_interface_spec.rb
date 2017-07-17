require 'rails_helper'

feature 'Search intefrace' do
  scenario 'create search' do
    visit root_path
    placeholder = ' add keywords here...'
    keywords = 'a'
    location = 'MyCity'
    expect(page).to have_field(id: 'search_keywords', placeholder: placeholder )
    fill_in 'search_keywords', with: keywords
    fill_in 'search_location_keywords', with: location
    expect { click_button('Search') }.to change(Search, :count).by(1)
    expect(page).to have_field(id: 'search_keywords', with: keywords )
    expect(page).to have_field(id: 'search_location_keywords', with: location )
  end
  scenario 'does not allow unlogged user to save search' do
    search = create(:search)
    visit search_path(search)
    expect(page).not_to have_button('save search')
  end
  scenario 'valid save search', js: true do
    user = create(:user)
    user.confirm 
    login_as(user, scope: :user)
    search = create(:search)
    visit search_path(search)
    click_button 'save search'
    expect(page).not_to have_button('save search')
    expect(page).to have_content('search saved! Click to show all your saved searches')
    click_link 'search saved! Click to show all your saved searches'
    expect(current_path).to eql searches_user_path(search)
    expect(page).to have_content(search.keywords)
  end
  scenario 'does show user search with proper links', js: true do
    user = create(:user)
    user.confirm 
    login_as(user, scope: :user)
    search = create(:search, user_id: user.id, time: Time.zone.now - 3.hours)
    keyword = search.keywords
    visit searches_user_path(user)
    expect(page).to have_content(keyword)
    expect(page).to have_link('delete')
    expect(page).to have_link('Show all tickets')
    # change link after add new ticket
    ticket = create(:ticket, title: keyword)
    visit searches_user_path(user)
    expect(page).to have_content(keyword)
    byebug
    expect(page).to have_link('Show new tickets')
  end
end