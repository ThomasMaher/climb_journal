json.id @session_climb&.id
json.attempts @session_climb&.attempts
json.percent_finished @session_climb&.percent_finished
json.notes @session_climb&.notes
json.extract! @boulder,
              :vgrade_range_min,
              :vgrade_range_max,
              :self_grade,
              :incline,
              :rating,
              :notes,
              :boulder_type,
              :nickname
