require 'rails_helper'

describe User do
  let(:user) { build(:user) }
  context 'model validations' do
    it { expect(user).to be_valid }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_length_of(:email).is_at_most 225 }
    it { is_expected.to validate_length_of(:password).is_at_least 6 }
    it { is_expected.to validate_length_of(:name).is_at_most 50 }
    
    it 'email validation should accept valid adresses' do
      valid_addresses = %w[user@foobar.com USER@foo.COM A_US-ER@foo.bar.org
		                 first.last@foo.jp alice+bob@baz.cn]
      valid_addresses.each do |valid_address|
	    user.email = valid_address
	    expect(user).to be_valid,  "#{valid_address.inspect} should be invalid"
	  end
    end

    it 'email validation should reject invalid addresses' do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).to_not be_valid, "#{invalid_address.inspect} should be invalid"
      end
    end

    it 'name should not be blank' do
      user.name = ' ' * 5
      expect(user).not_to be_valid
    end 

    it 'phone should not be too long' do
      user.phone = ('9' * 16).to_i
      expect(user).not_to be_valid
    end
  end

  context 'model associacions' do
  	before(:each) { user.save }
    it 'associated tickets should be destroyed' do
      ticket = user.tickets.build(title: 'Lorem ipsum',
                                  content: 'Lorem ipsum dolor sit amet',
                                  price: 100,
                                  ticket_type: 'paper',
                                  location: 'location')
      ticket.category = create(:subcategory_1)
      ticket.save
      expect { user.destroy }.to change { Ticket.count }.by(-1)
    end

    it 'associated searches should be destroyed' do
      search = user.searches.create(keywords: 'Lorem ipsum')
      expect { user.destroy }.to change { Search.count }.by(-1)
    end
  end

    it 'should follow and unfollow ticket' do
	  user = create(:user, email: 'foo@bar.com')
      ticket = create(:ticket)
      expect(user).not_to be_following(ticket)
      user.follow(ticket)
      expect(user).to be_following(ticket)
      expect(ticket.followers).to include(user)
      user.unfollow(ticket)
      expect(user).not_to be_following(ticket)
    end
  end