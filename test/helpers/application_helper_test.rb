require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full title helper' do
    assert_equal full_title,         'Ticket Market'
    assert_equal full_title('Help'), 'Help | Ticket Market'
  end
  
end