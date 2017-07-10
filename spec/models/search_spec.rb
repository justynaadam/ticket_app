require 'rails_helper'

describe Search do
	search = Search.new
	it { expect(search).to be_valid }
end