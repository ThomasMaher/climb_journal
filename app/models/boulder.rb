# == Schema Information
#
# Table name: boulders
#
#  id               :integer          not null, primary key
#  vgrade_range_min :integer
#  vgrade_range_max :integer
#  self_grade       :integer
#  attempts         :integer
#  percent_finished :integer
#  incline          :integer
#  indoor           :boolean
#  outdoor          :boolean
#  kilter_board     :boolean
#  nickname         :string(50)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Boulder < ApplicationRecord
  has_many :session_climbs

  validates :vgrade_range_min, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :vgrade_range_max,
            presence: true,
            numericality: {
              greater_than_or_equal_to: ->(boulder) {
                boulder.vgrade_range_min || boulder.vgrade_range_max+1
              }, message: "must be greater than or equal to vgrade range minimum"
            }
  validates :self_grade, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :incline, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 90 }, allow_nil: true
  validates :nickname, length: { maximum: 50 }, allow_nil: true
  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }, allow_nil: true
  validates :notes, length: { maximum: 400 }, allow_nil: true
  validate :climb_type_selected


  private

  def climb_type_selected
    selected = [
      self.indoor && 1 || 0,
      self.outdoor && 1 || 0,
      self.kilter_board && 1 || 0
    ].sum

    errors.add(:base, "At least one type (indoor, outdoor, kilter_board) must be selected") if selected.zero?
    errors.add(:base, "Select only one bouldering type (indoor, outdoor, kilter_board)") if selected > 1
  end
end

