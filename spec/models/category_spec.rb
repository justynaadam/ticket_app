require 'rails_helper'

describe Category do

	let(:category) { build(:category) }
	let(:subcategory) { build(:subcategory_1) }

  it "has a valid factory" do
    expect(category).to be_valid
    expect(subcategory).to be_valid
  end

  it { is_expected.to validate_presence_of(:text) }

  it 'text should be saved as a lower-case' do
  	mixed_case_text = 'FooExAMPle'
    subcategory.text = mixed_case_text
    subcategory.save
    expect(subcategory.text).to eq(mixed_case_text.downcase)
  end

  context 'model assiociations' do
    it { should belong_to(:main).class_name('Category') }
    it { should have_many(:subcategories).class_name('Category').with_foreign_key('main_id').dependent(:destroy) }
    it { should have_many(:tickets) }
  end


end