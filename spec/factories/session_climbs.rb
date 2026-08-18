# == Schema Information
#
# Table name: session_climbs
#
#  id               :integer          not null, primary key
#  session_id       :integer          not null
#  boulder_id       :integer          not null
#  user_id          :integer          not null
#  attempts         :integer
#  percent_finished :integer          not null
#  warmup           :boolean
#  notes            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_session_climbs_on_attempts                   (attempts)
#  index_session_climbs_on_boulder_id                 (boulder_id)
#  index_session_climbs_on_percent_finished           (percent_finished)
#  index_session_climbs_on_session_id_and_boulder_id  (session_id,boulder_id) UNIQUE
#  index_session_climbs_on_user_id                    (user_id)
#  index_session_climbs_on_warmup                     (warmup)
#

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
