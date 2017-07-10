FactoryGirl.define do

  factory :category do
    text 'category'
    created_at { 3.days.ago }
  end

  factory :subcategory_1, class: Category do
    text 'subcategory_1'
	created_at { 3.days.ago }
    association :main, factory: :category
   end
 end