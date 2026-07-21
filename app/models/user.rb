class User < ActiveRecord::Base
  has_many :sessions, dependent: :destroy
  has_many :session_climbs, dependent: :destroy
  has_many :boulders, through: :session_climbs

  def total_sessions(days_ago: nil)
    return sessions.size unless days_ago.present?

    sessions.where(
      'date > ?', Time.zone.now - days_ago.days
    ).size
  end

  def highest_grade(days_ago: nil)
    return boulders
             .joins(:session_climbs)
             .where('session_climbs.percent_finished = 100')
             .maximum(:vgrade_range_max) unless days_ago.present?

    sessions
      .joins(session_climbs: :boulder)
      .where('session_climbs.percent_finished = 100')
      .where('date > ?', Time.zone.now - days_ago.days)
      .maximum(:vgrade_range_max)
  end

  def avg_sent_grade(days_ago: nil)
    result = session_climbs.joins(:boulder, :session).where(percent_finished: 100)
    result = result.where("sessions.date > ?", Time.zone.now - days_ago.days) if days_ago.present?

    result.pick(Arel.sql(
      "ROUND(AVG( (boulders.vgrade_range_min + boulders.vgrade_range_max) / 2.0))"
    ))
  end

  def most_frequented_gym(days_ago: nil)
    return nil unless sessions.any?
    result = sessions.group(:gym_name).order(Arel.sql('COUNT(*) DESC'))
    return result.count.first unless days_ago.present?

    result.where(
        'date > ?', Time.zone.now - days_ago.days
    ).group(:gym_name).order(Arel.sql('COUNT(*) DESC')).count.first
  end

  def sends_by_grade(days_ago: nil)
    result = SessionClimb
      .joins(:boulder, :session)
      .where(user_id: id)
      .where(percent_finished: 100)
    result = result.where("sessions.date > ?", Time.zone.now - days_ago.days) if days_ago.present?

    result = result.group("boulders.vgrade_range_max").order("boulders.vgrade_range_max").count
    result.map { |grade, count| { vgrade: grade, sends: count } }
  end
end
