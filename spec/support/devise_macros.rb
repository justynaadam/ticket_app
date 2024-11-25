module DeviseMacros
  def login_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:user) # Using factory girl as an example
    end
  end
  def fillin_edit_ticket_form(args)
    fill_in 'Title', with: args[:title]
    fill_in 'Content', with: args[:content]
    select(args[:ticket_type])
    fill_in 'Price', with: args[:price]
    fill_in 'Location', with: args[:location]
    select(args[value: category])
    fill_in 'Name', with: args[:name]
    fill_in 'Phone', with: args[:phone]
  end
end