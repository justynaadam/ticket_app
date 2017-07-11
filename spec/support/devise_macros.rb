module DeviseMacros
  def login_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:user) # Using factory girl as an example
    end
  end
end