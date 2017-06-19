# frozen_string_literal: true

require 'test_helper'

class SearchIntefraceTest < ActionDispatch::IntegrationTest
  test 'should show simple search form on root page' do
    get root_path
    assert_template 'searches/_simple_search'
  end

  test 'should create search' do
    get root_path
    assert_template 'searches/_simple_search'
    keywords = 'a'
    location = 'MyCity'
    post searches_path, params: { search: { keywords: keywords,
                                            location_keywords: location } }
    follow_redirect!
    assert_template 'searches/show'
    assert_template 'searches/_search_form'
    assert_select "input[value=#{keywords}]"
    assert_select "input[value=#{location}]"
  end

  test 'should not allow unlogged user to save search' do
    @search = searches(:one)
    get search_path(@search)
    assert_select 'input[value="save search"]', false
    patch search_path(@search), params: { user_id: 1 }
    assert_redirected_to new_user_session_path
  end

  test 'should not allow save search to other user' do
    @search = searches(:one)
    @user = users(:one)
    sign_in @user
    @user.confirm
    @other_user = users(:two)
    get search_path(@search)
    assert_select 'input[value="save search"]'
    patch search_path(@search), params: { user_id: @other_user.id }
    assert_redirected_to root_url
  end

  test 'valid save search' do
    @search = searches(:one)
    @user = users(:one)
    sign_in @user
    @user.confirm
    get search_path(@search)
    assert_select 'input[value="save search"]'
    patch search_path(@search), params: { user_id: @user.id }
    assert_redirected_to search_path(@search)
    follow_redirect!
    assert_select 'input[value="save search"]', false
    @user.reload
    @search.reload
    assert @user.searches.include?(@search)
  end

  test 'should show user search with proper links' do
    @search = searches(:two)
    @user = users(:two)
    sign_in @user
    @user.confirm
    get searches_user_path(@user)
    assert_response :success
    assert_match "Keywords:\n#{@search.keywords}", response.body
    assert_select 'a[href=?]', search_path(@search), text: 'delete'
    assert_select 'a[href=?]', search_path(@search), text: 'Show all tickets'
    # change link after add new ticket
    @ticket = @user.tickets.build(title: @search.keywords.to_s, content: 'a', price: 10, ticket_type: 'a', location: 'a',
                                  activated: true, activated_at: Time.zone.now, category: categories(:subcategory_2))
    @ticket.save
    assert @ticket.valid?
    assert @ticket.title == @search.keywords
    get searches_user_path(@user)
    assert @search.new_tickets.include?(@ticket)
    assert_select 'a[href=?]', new_tickets_search_path(@search)
    assert_match 'Show new tickets', response.body
  end

  test 'should delete user search' do
    @search = searches(:two)
    @user = users(:two)
    sign_in @user
    @user.confirm
    assert @user.searches.include?(@search)
    assert_difference 'Search.count', -1 do
      delete search_path(@search)
    end
    assert_not @user.reload.searches.include?(@search)
  end

  test 'should not delete user search by unlogged user' do
    @search = searches(:two)
    @user = users(:two)
    assert @user.searches.include?(@search)
    assert_no_difference 'Search.count' do
      delete search_path(@search)
    end
  end

  test 'should not delete different user search' do
    @search = searches(:two)
    @user = users(:two)
    sign_in users(:one)
    users(:one).confirm
    assert @user.searches.include?(@search)
    assert_no_difference 'Search.count' do
      delete search_path(@search)
    end
    assert_redirected_to root_path
  end
end
