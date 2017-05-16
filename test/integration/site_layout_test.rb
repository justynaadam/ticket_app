# frozen_string_literal: true

require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test 'layout links' do
    get home_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
  end

  test 'should get right title' do
    get home_path
    assert_select 'title', full_title('Home')
    get help_path
    assert_select 'title', full_title('Help')
  end
end
