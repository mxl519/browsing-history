require 'rails_helper'

describe AppsUsersController do
  describe '#index' do
    context 'with sign_in' do
      before do
        sign_in FactoryGirl.create(:user)
      end

      it 'gets index and returns recent app history for user' do
        history = {'App' => 'Date'}
        expect(controller.current_user).to receive(:recent_app_history).and_return(history)

        get :index

        expect(response.status).to be 200
        expect(response.body).to eq(history.to_json)
      end
    end

    context 'without sign_in' do
      it 'redirects to sign-in' do
        get :index

        expect(response.status).to be 302
      end
    end
  end

  describe '#create' do
    context 'with sign_in' do
      let(:app) { FactoryGirl.create(:app) }

      before do
        sign_in FactoryGirl.create(:user)
      end

      it 'posts index and creates a new AppsUsers association' do
        expect {
          post :create, params: { 'app_name' => app.name }
        }.to change{ AppsUsers.count }.by(1)

        expect(response.status).to be 201
        expect(AppsUsers.last.app.id).to be app.id
      end
    end

    context 'without sign_in' do
      it 'redirects to sign-in' do
        post :create, params: {}

        expect(response.status).to be 302
      end
    end
  end

  describe '#destroy' do
    context 'with sign_in' do
      before do
        sign_in FactoryGirl.create(:user)
        FactoryGirl.create(:apps_users, user: controller.current_user)
      end

      it 'deletes destroy and deletes all history of current_user' do
        expect(AppsUsers.count).to be > 0

        delete :destroy

        expect(response.status).to be 204
        expect(AppsUsers.count).to be 0
      end
    end

    context 'without sign_in' do
      it 'redirects to sign-in' do
        delete :destroy

        expect(response.status).to be 302
      end
    end
  end
end
