require 'rails_helper'

describe Search do
  search = Search.new
  it { expect(search).to be_valid }

  context 'model associacion' do
    it { should belong_to(:user) }
  end
end