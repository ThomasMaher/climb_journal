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