json.extract! sclimb, :id, :warmup, :attempts, :percent_finished, :notes
json.boulder_id sclimb&.boulder&.id
json.extract! sclimb&.boulder,
              :vgrade_range_min,
              :vgrade_range_max,
              :self_grade,
              :incline,
              :rating,
              :notes,
              :boulder_type,
              :nickname
