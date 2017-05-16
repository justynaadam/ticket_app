# frozen_string_literal: true

require 'test_helper'

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get new_search_path
    assert_response :success
  end

  test 'should get show' do
    get search_path(searches(:one))
    assert_response :success
  end
end
