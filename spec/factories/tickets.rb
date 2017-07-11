FactoryGirl.define do
  
  factory :ticket do
	title 'Lorem ipsum'
	content 'Lorem ipsum dolor sit amet'
	price 100
	ticket_type 'paper'
	location 'Location'
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