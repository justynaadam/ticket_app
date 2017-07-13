FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  factory :user do
	email
	password 'password1'

	factory :other_user do
	  email
	end
  end
end