require 'rails_helper'

describe Relationship do
  let(:relationship) { Relationship.new(follower: create(:user),
		                                    followed: create(:other_user_ticket) ) }
  it { expect(relationship).to be_valid }
  
  it 'is invalid without a follower' do
  	relationship.follower_id = nil
  	relationship.valid?
  	expect(relationship.errors[:follower_id]).to include("can't be blank")
  end

  it 'is invalid without a followed' do
  	relationship.followed_id = nil
  	relationship.valid?
  	expect(relationship.errors[:followed_id]).to include("can't be blank")
  end

  context 'model assiociations' do
    it { should belong_to(:follower).class_name('User') }
    it { should belong_to(:followed).class_name('Ticket') }
  end

end
