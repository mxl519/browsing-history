require 'rails_helper'

describe App, type: :model do
  it { is_expected.to have_and_belong_to_many :users }

  describe '.listing' do
    let!(:app1) { FactoryGirl.create(:app, name: "App1", assets: ["url1.com"]) }
    let!(:app2) { FactoryGirl.create(:app, name: "App2", assets: ["url2.com"]) }

    it 'lists all apps by name and urls' do
      expect(App.listing).to eq([{'name' => 'App1', 'urls' => ['url1.com']}, {'name' => 'App2', 'urls' => ['url2.com']}])
    end
  end
end
