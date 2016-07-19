require 'rails_helper'

describe AppController do
  describe '#index' do
    context 'with sign_in' do
      before do
        sign_in FactoryGirl.create(:user)
      end

      it 'gets index and returns App.listing' do
        listing = [{'name' => 'App', 'urls' => ['urls.com']}]
        expect(App).to receive(:listing).and_return(listing)

        get :index

        expect(response.status).to be 200
        expect(response.body).to eq(listing.to_json)
      end
    end

    context 'without sign_in' do
      it 'redirects to sign-in' do
        get :index

        expect(response.status).to be 302
      end
    end
  end
end
