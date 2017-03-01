require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  
  def setup
    @main_category = Category.new(text: 'event')
    @subcategory = Category.new(text: 'subcategory', main_id: 1)
  end

  test 'main category should be valid' do
    assert @main_category.valid?
  end

  test 'subcategory should be valid' do
    assert @subcategory.valid?
  end

  test 'text should be present' do
    @main_category.text = nil
    @subcategory.text = nil
    assert_not @main_category.valid?
    assert_not @subcategory.valid?
  end
end
