FactoryBot.define do
  factory :session do
    date { Time.zone.today - 1.day }
    gym_name { 'Climbing Gym Sen' }
  end
end