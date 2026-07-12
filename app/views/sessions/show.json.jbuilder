json.extract! @session, :id, :date, :gym_name, :notes
json.boulders @session.session_climbs do |sclimb|
  json.extract! sclimb, :id, :attempts, :percent_finished, :notes
  json.extract! sclimb.boulder,
    :vgrade_range_min,
    :vgrade_range_max,
    :self_grade,
    :incline,
    :rating,
    :notes,
    :boulder_type,
    :nickname
end