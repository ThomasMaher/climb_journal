# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  date       :date             not null
#  gym_name   :string(50)       not null
#  user_id    :integer          not null
#  notes      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_sessions_on_date      (date)
#  index_sessions_on_gym_name  (gym_name)
#  index_sessions_on_user_id   (user_id)
#

FactoryBot.define do
  factory :session do
    date { Time.zone.today - 1.day }
    gym_name { 'Climbing Gym Sen' }
  end
end
