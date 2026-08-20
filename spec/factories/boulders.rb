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
#  notes            :text
#  boulder_type     :string
#  nickname         :string(50)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  created_by_id    :integer
#
# Indexes
#
#  index_boulders_on_boulder_type      (boulder_type)
#  index_boulders_on_created_by_id     (created_by_id)
#  index_boulders_on_incline           (incline)
#  index_boulders_on_nickname          (nickname)
#  index_boulders_on_rating            (rating)
#  index_boulders_on_self_grade        (self_grade)
#  index_boulders_on_vgrade_range_max  (vgrade_range_max)
#  index_boulders_on_vgrade_range_min  (vgrade_range_min)
#

FactoryBot.define do
  factory :boulder do
    vgrade_range_max { 3 }
    vgrade_range_min { 1 }
    self_grade { 2 }
    incline { 0 }
    boulder_type { 'Indoor' }
  end
end
