FactoryBot.define do
  factory :session_climb do
    attempts { 1 }
    percent_finished { 0 }
    warmup { false }

    trait :sent do
      percent_finished { 100 }
    end

    trait :warmup do
      warmup { true }
    end
  end
end
