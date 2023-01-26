require 'rails_helper'

describe Contact do
  before do
    Contact.destroy_all
    Referral.destroy_all

    @contact1 = create(:contact, name: "Test User 1", email: "test1@influitive.com", points: 0)
    @contact2 = create(:contact, name: "Test User 2", email: "test2@influitive.com", points: 0)
    @contact3 = create(:contact, name: "Test User 3", email: "test3@influitive.com", points: 0)
    @contact4 = create(:contact, name: "Test User 4", email: "test3@influitive.com", points: 0)

    @contact1.referrals.create!(name: "Referred User 1", email: "referral1@influitive.com")

    @contact2.referrals.create!(name: "Referred User 3", email: "referral3@influitive.com")
    @contact2.referrals.create!(name: "Referred User 3", email: "referral3@influitive.com")
    @contact2.referrals.create!(name: "Referred User 3", email: "referral3@influitive.com")

    @contact3.referrals.create!(name: "Referred User 3", email: "referral3@influitive.com")
    @contact3.referrals.create!(name: "Referred User 3", email: "referral3@influitive.com")
  end

  describe '.for_leaderboard' do
    it 'returns a list of contacts sorted by their refferral counts' do
      expect(Contact.for_leaderboard.map { |c| c['id'] }).to eq([
        @contact2.id, @contact3.id, @contact1.id, @contact4.id
      ])
    end
  end
end
