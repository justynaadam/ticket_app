# frozen_string_literal: true

require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = 'Ticket Market'
  end

  test 'should get home' do
    get home_path
    assert_response :success
    assert_select 'title', "Home | #{@base_title}"
  end

  test 'should get help' do
    get help_path
    assert_response :success
    assert_select 'title', "Help | #{@base_title}"
  end
end
