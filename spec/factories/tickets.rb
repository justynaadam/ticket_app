FactoryGirl.define do
  
  factory :ticket do
	title Faker::Lorem.sentence
	content Faker::Lorem.sentence
	price 100
	ticket_type 'paper'
	location Faker::GameOfThrones.city
	user
	association :category, factory: :subcategory_1
	activated :true
	activated_at { 2.hours.ago }

	factory :non_activated do
	  activated nil
	  activated_at nil
	end

    factory :other_user_ticket do
      association :user, factory: :other_user
    end
  end

  
end