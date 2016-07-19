require 'rails_helper'

describe ApplicationController do
  describe '#index' do
    context 'with sign_in' do
      before do
        sign_in FactoryGirl.create(:user)
      end

      it 'gets index' do
        get :index

        expect(response.status).to be 200
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
