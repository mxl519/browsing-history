FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@hotmail.com" }
    password 'Password1'
  end
end
