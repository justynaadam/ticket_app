FactoryGirl.define do

  factory :category do
    text 'category'
    created_at { 3.days.ago }
  end

  factory :subcategory_1, class: Category do
    text Faker::GameOfThrones.city
	  created_at { 3.days.ago }
    association :main, factory: :category
   end
   factory :subcategory_2, class: Category do
    text Faker::GameOfThrones.city
    created_at { 3.days.ago }
    association :main, factory: :category
   end
   factory :subcategory_3, class: Category do
    text Faker::GameOfThrones.city
    created_at { 3.days.ago }
    association :main, factory: :category
   end
 end