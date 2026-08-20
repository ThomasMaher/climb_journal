class UserBoulderDataService
  def initialize(boulder_id, user_id)
    @session_climbs = SessionClimb.where(boulder_id: boulder_id, user_id: user_id)
  end

  def run
    {
      total_sessions: total_sessions,
      current_progress: current_progress,
      total_attempts: total_attempts,
      date_completed: date_completed,
      last_date_climbed: last_date_climbed
    }
  end


  private

  def total_sessions
    @session_climbs.count
  end

  def current_progress
    @session_climbs.reduce(0) { |max, session| session.percent_finished > max ? session.percent_finished : max }
  end

  def total_attempts
    @session_climbs.reduce(0) { |sum, session| sum + session.attempts }
  end

  def date_completed
    return unless current_progress == 100

    @session_climbs
             .joins(:session)
             .select(:date)
             .sent
             .order("sessions.date DESC")
             .first
             &.date
  end

  def last_date_climbed
    @session_climbs
      .joins(:session)
      .select(:date)
      .order("sessions.date DESC")
      .first
      &.date
  end
end