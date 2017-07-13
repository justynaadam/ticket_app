require 'rails_helper'

describe User do
  let(:user) { build(:user) }
  context 'model validations' do
    it { expect(user).to be_valid }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
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
        user.valid?
        expect(user.errors[:email]).to include('is invalid'), "#{invalid_address.inspect} should be invalid"
      end
    end

    it 'email adresses should be unique' do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save
      duplicate_user.valid?
      expect(duplicate_user.errors[:email]).to include("has already been taken")
    end

    it 'name should not be blank' do
      user.name = ''
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end 

    it 'phone should not be too long' do
      user.phone = Faker::Number.number(16).to_i
      user.valid?
      expect(user.errors[:phone]).to include("is too long (maximum is 15 characters)")
    end
  end

  context 'model associacions' do
    it { should have_many(:tickets).dependent(:destroy) }
    it { should have_many(:relationships).with_foreign_key('follower_id').dependent(:destroy) }
    it { should have_many(:following).through(:relationships).source(:followed) }
    it { should have_many(:searches).dependent(:destroy) }
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