require 'rails_helper'

describe Ticket do
  let(:ticket) { build(:ticket) }
  context 'model validations' do
    before { ticket }
    it { expect(ticket).to be_valid }

    it 'is invalid without a user' do
      ticket.user_id = nil
      ticket.valid?
      expect(ticket.errors[:user_id]).to include("can't be blank")
    end

    it 'is invalid without a title' do
      ticket.title = '   '
      ticket.valid?
      expect(ticket.errors[:title]).to include("can't be blank")
    end

    it 'is invalid without a content' do
      ticket.content = '   '
      ticket.valid?
      expect(ticket.errors[:content]).to include("can't be blank")
    end

    it 'is invalid without a price' do
      ticket.price = '   '
      ticket.valid?
      expect(ticket.errors[:price]).to include("can't be blank")
    end

    it 'is invalid without a ticket_type' do
      ticket.ticket_type = '   '
      ticket.valid?
      expect(ticket.errors[:ticket_type]).to include("can't be blank")
    end

    it 'is invalid without a location' do
      ticket.location = '   '
      ticket.valid?
      expect(ticket.errors[:location]).to include("can't be blank")
    end

    it 'title should be at most 70 characters' do
      ticket.title = 'a' * 71
      ticket.valid?
      expect(ticket.errors[:title]).to include("is too long (maximum is 70 characters)")
    end

    it 'content should be at most 4096 characters' do
      ticket.content = 'a' * 4097
      ticket.valid?
      expect(ticket.errors[:content]).to include("is too long (maximum is 4096 characters)")
    end

    it 'price should be greater or equal zero' do
      ticket.price = -1
      ticket.valid?
      expect(ticket.errors[:price]).to include("must be greater than or equal to 0")
    end

    it 'location should be at most 50 characters' do
      ticket.location = 'a' * 51
      ticket.valid?
      expect(ticket.errors[:location]).to include("is too long (maximum is 50 characters)")
    end

    it 'ticket should not belongs to main category' do
      ticket.category = create(:category)
      ticket.valid?
      expect(ticket.errors[:category_id]).to include("should choose subcategory")
    end
  end

  context 'model assiociations' do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
    it { should have_many(:relationships) }
    it { should have_many(:followers) }
  end

  
  describe 'finding previous and next ticket' do
    before(:each) do
      ticket.save
      @first  = create(:ticket, updated_at: (ticket.updated_at - 2.minutes), category: ticket.category )
      @second = create(:ticket, updated_at: (ticket.updated_at - 1.minutes), category: ticket.category )
      @third  = create(:ticket, updated_at: (ticket.updated_at + 1.minutes), category: ticket.category )
      @fourth = create(:ticket, updated_at: (ticket.updated_at + 2.minutes), category: ticket.category )
    end
      it 'returns previous ticket' do
        previous_t = ticket.find_previous(ticket.updated_at, ticket.category_id)
        expect(previous_t).to eq(@third)
      end
      it 'returns next ticket' do
        next_t = ticket.find_next(ticket.updated_at, ticket.category_id)
        expect(next_t).to eq(@second)
      end
  end
end
