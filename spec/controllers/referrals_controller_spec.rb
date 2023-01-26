require 'rails_helper'

describe ReferralsController do
  describe '#index' do
    before do
      Contact.destroy_all
      Referral.destroy_all

      contact1 = create(:contact, name: 'Michael Smith', email: 'michael@gmail.com')
      contact2 = create(:contact, name: 'Matt Quinn', email: 'matt.quinn@influitive.com')

      create(:referral, contact: contact2, name: 'Herman', email: 'herman@influitive.com', created_at: 3.days.ago)
      create(:referral, contact: contact1, name: 'Will Whitby', email: 'will@gmail.com', created_at: 2.days.ago)
      create(:referral, contact: contact1, name: 'Jane Doe', email: 'jane@gmail.com', created_at: 1.days.ago)
    end

    context 'when no filters or params are passed' do
      let(:payload) do
        [
          {
            name: 'Jane Doe',
            email: 'jane@gmail.com',
            created_at: String,
            referrer: {
              name: 'Michael Smith',
              email: 'michael@gmail.com'
            }
          },
          {
            name: 'Will Whitby',
            email: 'will@gmail.com',
            created_at: String,
            referrer: {
              name: 'Michael Smith',
              email: 'michael@gmail.com'
            }
          },
          {
            name: 'Herman',
            email: 'herman@influitive.com',
            created_at: String,
            referrer: {
              name: 'Matt Quinn',
              email: 'matt.quinn@influitive.com'
            }
          }
        ].ordered!
      end

      it 'returns all referrals sorted by created_at descending' do
        get :index
        expect(response.body).to match_json_expression(payload)
      end
    end

    context 'when a sort order is provided' do
      let(:payload) do
        [
          {
            name: 'Herman',
            email: 'herman@influitive.com',
            created_at: String,
            referrer: {
              name: 'Matt Quinn',
              email: 'matt.quinn@influitive.com'
            }
          },
          {
            name: 'Will Whitby',
            email: 'will@gmail.com',
            created_at: String,
            referrer: {
              name: 'Michael Smith',
              email: 'michael@gmail.com'
            }
          },
          {
            name: 'Jane Doe',
            email: 'jane@gmail.com',
            created_at: String,
            referrer: {
              name: 'Michael Smith',
              email: 'michael@gmail.com'
            }
          }
        ].ordered!
      end

      it 'returns all referrals sorted by created_at in the order requested' do
        get :index, sort_order: 'asc'

        expect(response.body).to match_json_expression(payload)
      end
    end

    context 'when a per_page is provided' do
      let(:payload) do
        [
          {
            name: 'Jane Doe',
            email: 'jane@gmail.com',
            created_at: String,
            referrer: {
              name: 'Michael Smith',
              email: 'michael@gmail.com'
            }
          }
        ]
      end

      it 'returns the amount of referrals indicated by the per_page' do
        get :index, per_page: 1
        expect(response.body).to match_json_expression(payload)
      end
    end

    context 'when a page is provided' do
      let(:payload) do
        [
          {
            name: 'Will Whitby',
            email: 'will@gmail.com',
            created_at: String,
            referrer: {
              name: 'Michael Smith',
              email: 'michael@gmail.com'
            }
          }
        ].ordered!
      end

      it 'returns the collection offsetted by the page params' do
        get :index, page: 2, per_page: 1
        expect(response.body).to match_json_expression(payload)
      end
    end

    context 'when multiple properties are provided' do
      let(:payload) do
        [
          {
            name: 'Herman',
            email: 'herman@influitive.com',
            created_at: String,
            referrer: {
              name: 'Matt Quinn',
              email: 'matt.quinn@influitive.com'
            }
          },
          {
            name: 'Will Whitby',
            email: 'will@gmail.com',
            created_at: String,
            referrer: {
              name: 'Michael Smith',
              email: 'michael@gmail.com'
            }
          }
        ].ordered!
      end

      it 'returns the correct collection' do
        get :index, sort_order: 'asc', per_page: 2, page: 1
        expect(response.body).to match_json_expression(payload)
      end
    end
  end

  describe '#create' do
    before do
      Contact.destroy_all
      create(:contact, email: "test1@influitive.com")
    end

    let(:current_contact) { Contact.find_by(email: "test1@influitive.com") }

    context 'when the params submitted are valid' do
      it 'creates a referral' do
        expect {
          post :create, name: 'Alex', email: 'alex@hotmail.com'
        }.to change(Referral, :count).by(1)
      end

      it 'increases the referrers points by 100' do
        post :create, name: 'Alex', email: 'alex@hotmail.com'

        expect(current_contact.reload.points).to eq(100)
      end

      it 'creates an event associated to the contact' do
        expect {
          post :create, name: 'Alex', email: 'alex@hotmail.com'
        }.to change(Event, :count).by(1)

        expect(Event.last.contact).to eq(current_contact)
      end

      it 'makes a call to the slack Notfier' do
        expect(SlackNotifier).to receive(:notify).with(current_contact.id, 'referral_submitted')
        post :create, name: 'Alex', email: 'alex@hotmail.com'
      end
    end

    context 'when the params submitted are not valid' do
      it 'does not create objects' do
        expect {
          post :create, name: 'Alex', email: ''
        }.not_to change(Referral, :count)
      end
    end

    context 'when the SlackNotifier raises an error' do
      it 'does not create objects' do
        allow(SlackNotifier).to receive(:notify).and_raise("Boom")

        expect {
          post :create, name: 'Alex', email: 'alex@hotmail.com'
        }.not_to change(Referral, :count)
      end
    end
  end
end
