require 'test_helper'

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get searches_new_url
    assert_response :success
  end

  test "should get show" do
    get search_path(searches(:one))
    assert_response :success
  end

end
