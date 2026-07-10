# == Schema Information
#
# Table name: boulders
#
#  id               :integer          not null, primary key
#  vgrade_range_min :integer          not null
#  vgrade_range_max :integer
#  self_grade       :integer
#  incline          :integer
#  rating           :integer
#  notes            :text(65535)
#  boulder_type     :string(255)
#  nickname         :string(50)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_boulders_on_boulder_type      (boulder_type)
#  index_boulders_on_incline           (incline)
#  index_boulders_on_nickname          (nickname)
#  index_boulders_on_rating            (rating)
#  index_boulders_on_self_grade        (self_grade)
#  index_boulders_on_vgrade_range_max  (vgrade_range_max)
#  index_boulders_on_vgrade_range_min  (vgrade_range_min)
#

class Boulder < ApplicationRecord
  BOULDER_TYPES = [ "Indoor", "Outdoor", "Kilter Board" ].freeze

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
  validates :boulder_type, inclusion: BOULDER_TYPES, allow_nil: true
end

