require 'test_helper'
class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    Devise.mailer.deliveries.clear
  end

  test 'invalid signup information' do
    get new_user_registration_path
    assert_no_difference 'User.count' do
      post user_registration_path, params: { user: { email: 'user@invalid',
                                                     password: 'foo',
                                                     password_confirmation: 'bar' } }
    end
    assert_template 'devise/registrations/new'
  end
  
  test 'valid signup information with acctivation' do
    get new_user_registration_path
    assert_difference 'User.count', 1 do
      post user_registration_path, params: { user: { email: 'user@valid.com',
                                                     password: 'foobar',
                                                     password_confirmation: 'foobar' } }
    end
    assert_redirected_to root_path
    assert_equal 1, Devise.mailer.deliveries.count
  end
end
