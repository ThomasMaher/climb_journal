class UserStatsService
  def initialize(user)
    @user = user
    @sessions ||= user.sessions.joins(session_climbs: :boulder)
  end
  attr_reader :user
  attr_accessor :days_ago

  delegate :sessions, to: :user
  delegate :boulders, to: :user
  delegate :session_climbs, to: :user

  def run(days_ago: nil)
    @days_ago = days_ago
    {
      total_sessions: total_sessions,
      highest_grade: highest_grade_sent,
      avg_sent_grade: avg_sent_grade,
      most_frequented_gym: most_frequented_gym,
      sends_by_grade: sends_by_grade
    }
  end


  private

  def total_sessions
    return sessions.size unless @days_ago.present?

    sessions.on_or_after(Time.zone.today - days_ago).size
  end

  def highest_grade_sent
    return boulders
             .joins(:session_climbs)
             .where('session_climbs.percent_finished = 100')
             .maximum(:vgrade_range_max) unless @days_ago.present?

    @sessions
      .on_or_after(@days_ago)
      .where('session_climbs.percent_finished = 100')
      .maximum(:vgrade_range_max)
  end

  def avg_sent_grade
    result = session_climbs.joins(:boulder, :session).where(percent_finished: 100)
    result = result.where('sessions.date >= ?', Time.zone.today - @days_ago.days) if @days_ago.present?

    result.pick(Arel.sql(
      "ROUND(AVG( (boulders.vgrade_range_min + boulders.vgrade_range_max) / 2.0))::integer"
    ))
  end

  def most_frequented_gym
    return nil unless sessions.any?
    result = sessions.group(:gym_name).order(Arel.sql('COUNT(*) DESC'))
    return result.count.first[0] unless @days_ago.present?

    result = result.on_or_after(@days_ago).group(:gym_name).order(Arel.sql('COUNT(*) DESC')).count
    result.present? ? result.first[0] : ''
  end

  def sends_by_grade
    result = @sessions.where('session_climbs.percent_finished = 100')
    result = result.on_or_after(@days_ago) if @days_ago.present?

    result = result.group("boulders.vgrade_range_max").order("boulders.vgrade_range_max").count
    result.map { |grade, count| { vgrade: grade, sends: count } }
  end
end