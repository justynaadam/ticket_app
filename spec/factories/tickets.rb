FactoryGirl.define do
  
  factory :ticket do
	title 'Lorem ipsum'
	content 'Lorem ipsum dolor sit amet'
	price 100
	ticket_type 'paper'
	location 'Location'
	user
	association :category, factory: :subcategory_1
  end
end