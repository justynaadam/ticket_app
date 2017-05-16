# frozen_string_literal: true

require 'test_helper'

class Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @category = categories(:subcategory_1)
    @admin = users(:admin)
    @admin.confirm
  end

  test 'should not get new as non admin' do
    get new_admin_category_path
    assert_redirected_to root_path
  end

  test 'should not get index as non admin' do
    get admin_categories_path
    assert_redirected_to root_path
  end

  test 'should not get edit as non admin' do
    get edit_admin_category_path(@category)
    assert_redirected_to root_path
  end

  test 'should not delete category as non admin' do
    assert_no_difference 'Category.count' do
      delete admin_category_path(@category)
    end
    assert_redirected_to root_path
  end

  test 'should get new' do
    sign_in @admin
    get new_admin_category_path
    assert_response :success
  end

  test 'should get index' do
    sign_in @admin
    get admin_categories_path
    assert_response :success
  end

  test 'should get edit' do
    sign_in @admin
    get edit_admin_category_path(@category)
    assert_response :success
  end

  test 'create invalid category' do
    sign_in @admin
    assert_no_difference 'Category.count' do
      post admin_categories_path, params: { category: { text: ' ' } }
    end
    assert_template 'categories/new'
  end

  test 'create valid category' do
    sign_in @admin
    assert_difference 'Category.count', 1 do
      post admin_categories_path, params: { category: { text: 'new category' } }
    end
    assert_redirected_to admin_categories_path
    assert flash.present?
  end

  test 'invalid update' do
    sign_in @admin
    patch admin_category_path(@category), params: { category: { text: '' } }
    assert @category.text == @category.reload.text
    assert_template 'edit'
  end

  test 'valid update' do
    sign_in @admin
    text = 'new category'
    patch admin_category_path(@category), params: { category: { text: text } }
    assert @category.reload.text = text
    assert_redirected_to admin_categories_path
    assert flash.present?
  end

  test 'should delete category' do
    sign_in @admin
    assert_difference 'Category.count', -1 do
      delete admin_category_path(@category)
    end
    assert_redirected_to admin_categories_path
    assert flash.present?
  end
end
