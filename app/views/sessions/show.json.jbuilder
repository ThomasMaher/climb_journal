json.extract! @session, :id, :date, :gym_name, :notes
[:warmup, :not_warmup].each do |warmup_type|
  json.set! warmup_type do
    json.array! @session.session_climbs.send(warmup_type).each do |sclimb|
      json.extract! sclimb, :id, :warmup, :attempts, :percent_finished, :notes
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
  end
end
