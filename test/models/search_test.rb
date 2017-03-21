require 'test_helper'

class SearchTest < ActiveSupport::TestCase

  def setup
    @search = Search.new
  end
  
  test 'should be valid' do
    assert @search.valid?
  end
end
