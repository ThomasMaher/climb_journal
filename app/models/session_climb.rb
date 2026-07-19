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
#  notes            :text(65535)
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
#

class SessionClimb < ApplicationRecord
  belongs_to :boulder
  belongs_to :session

  validates :attempts, numericality: { greater_than_or_equal_to: 0 }
  validates :percent_finished, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :notes, length: { maximum: 400 }, allow_nil: true
  validates :boulder_id, uniqueness: {
    scope: :session_id,
    message: "has already been added to this session"
  }

  before_validation :set_initial_state


  private

  def set_initial_state
    self.attempts = 0 if self.attempts.nil?
    self.percent_finished = 0 if self.percent_finished.nil?
  end
end
