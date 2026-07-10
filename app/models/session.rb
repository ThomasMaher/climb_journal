# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  date       :date             not null
#  gym_name   :string(50)       not null
#  notes      :text(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_sessions_on_date      (date)
#  index_sessions_on_gym_name  (gym_name)
#

class Session < ApplicationRecord
    has_many :session_climbs

    validates :date, presence: true
    validates :gym_name, presence: true, length: { maximum: 50 }
    validates :notes, length: { maximum: 255 }
end
