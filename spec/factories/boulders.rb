FactoryBot.define do
  factory :boulder do
    vgrade_range_max { 3 }
    vgrade_range_min { 1 }
    self_grade { 2 }
    incline { 0 }
    boulder_type { 'Indoor' }
  end
end
