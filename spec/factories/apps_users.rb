FactoryGirl.define do
  factory :apps_users do
    association :app
    association :user
  end
end
