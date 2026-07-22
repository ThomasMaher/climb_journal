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

class Session < ApplicationRecord
    has_many :session_climbs
    belongs_to :user

    validates :date, presence: true
    validates :gym_name, presence: true, length: { maximum: 50 }
    validates :notes, length: { maximum: 255 }

    scope :on_or_after, ->(start_date) {
        where('date >= ?', (start_date.is_a?(Date) ? start_date : Time.zone.now - start_date.days))
    }
end
