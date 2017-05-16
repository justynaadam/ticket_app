# frozen_string_literal: true

# Preview all emails at https://ticket-market-somethingtimeless.c9users.io/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview at https://ticket-market-somethingtimeless.c9users.io/rails/mailers/user_mailer/confirmation_instructions
  def confirmation_instructions
    UserMailer.confirmation_instructions(User.first, 'faketoken', {})
  end

  # Preview at https://ticket-market-somethingtimeless.c9users.io/rails/mailers/user_mailer/reset_password_instructions
  def reset_password_instructions
    UserMailer.reset_password_instructions(User.first, 'faketoken', {})
  end
end
