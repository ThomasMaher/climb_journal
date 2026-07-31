FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "climber#{n}" }
    password { "password123" }
  end
end
