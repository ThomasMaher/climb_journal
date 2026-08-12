class SessionStatsService
  def initialize(session)
    @session = session
  end

  def run
    {
      total_boulders: total_boulders,
      highest_grade_sent: highest_grade_sent,
      sends_by_grade: sends_by_grade
    }
  end


  private

  def total_boulders
    @session.session_climbs.not_warmup.count
  end

  def highest_grade_sent
    @session.session_climbs.not_warmup.max_by(&:vgrade_range_max)&.vgrade_range_max
  end

  def sends_by_grade
    result = @session.session_climbs.joins(:boulder).not_warmup.sent

    result = result.group("boulders.vgrade_range_max").order("boulders.vgrade_range_max").count
    result.map { |grade, count| { vgrade: grade, sends: count } }
  end
end
