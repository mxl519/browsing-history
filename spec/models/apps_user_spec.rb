require 'rails_helper'

describe AppsUsers, type: :model do
  it { is_expected.to belong_to :app }
  it { is_expected.to belong_to :user }
end
