json.array! @boulder.session_climbs.each do |sclimb|
  json.extract! sclimb,
                :id,
                :session_id,
                :warmup,
                :attempts,
                :percent_finished,
                :notes,
                :date
end
