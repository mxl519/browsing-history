require 'rails_helper'

describe User, type: :model do
  it { is_expected.to have_and_belong_to_many :apps }

  describe '#recent_app_history' do
    subject { FactoryGirl.create(:user)}

    let!(:app1) { FactoryGirl.create(:app) }
    let!(:app1_this_user1) { FactoryGirl.create(:apps_users, app: app1, user: subject) }
    let!(:app1_this_user2) { FactoryGirl.create(:apps_users, app: app1, user: subject) }

    let!(:app2) { FactoryGirl.create(:app) }
    let!(:app2_this_user) { FactoryGirl.create(:apps_users, app: app2, user: subject) }
    let!(:old_app2_this_user) { FactoryGirl.create(:apps_users, app: app2, user: subject, created_at: 2.days.ago) }

    let!(:app3) { FactoryGirl.create(:app) }
    let!(:app3_this_user) { FactoryGirl.create(:apps_users, app: app3, user: subject) }
    let!(:app3_another_user) { FactoryGirl.create(:apps_users, app: app3) }

    let!(:app4) { FactoryGirl.create(:app) }

    it 'lists apps_users from the past day with app name' do
      expect(subject.recent_app_history).to eq(app1.name => app1_this_user2.created_at.to_s(:db),
                                               app2.name => app2_this_user.created_at.to_s(:db),
                                               app3.name => app3_this_user.created_at.to_s(:db))
    end
  end
end
