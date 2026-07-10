# == Schema Information
#
# Table name: session_climbs
#
#  id               :integer          not null, primary key
#  session_id       :integer          not null
#  boulder_id       :integer          not null
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
#

class SessionClimb < ApplicationRecord
  belongs_to :boulder
  belongs_to :session

  validates :attempts, numericality: { greater_than_or_equal_to: 0 }
  validates :percent_finished, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :boulder_id, uniqueness: {
    scope: :session_id,
    message: "has already been added to this session"
  }

  before_save :set_percent_finished


  private

  def set_percent_finished
    unless self.percent_finished.positive?
      self.percent_finished = 0
    end
  end
end
