json.id @session_climb&.id
json.session_id @session_climb&.session_id
json.attempts @session_climb&.attempts
json.percent_finished @session_climb&.percent_finished
json.warmup @session_climb&.warmup
json.notes @session_climb&.notes
json.boulder_id @boulder&.id
if @boulder.present?
  json.extract! @boulder,
                :vgrade_range_min,
                :vgrade_range_max,
                :self_grade,
                :incline,
                :rating,
                :notes,
                :boulder_type,
                :nickname
end