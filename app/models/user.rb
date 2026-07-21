class User < ActiveRecord::Base
  has_many :sessions, dependent: :destroy
  has_many :session_climbs, dependent: :destroy
  has_many :boulders, through: :session_climbs

  def total_sessions(days_ago: nil)
    return sessions.size unless days_ago.present?

    sessions.where(
      'created_at > ?', Time.zone.now - days_ago
    ).size
  end

  def highest_grade(days_ago: nil)
    return boulders.maximum(:vgrade_range_max) unless days_ago.present?

    boulders.where(
      'created_at < ?', Time.zone.now - days_ago
    ).maximum(:vgrade_range_max)
  end

  def avg_sent_grade(days_ago: nil)
    result = session_climbs.joins(:boulder)
    result = result.where("session_climbs.created_at > ?", Time.zone.now - days_ago) if days_ago.present?

    result.pick(Arel.sql(
      "ROUND(AVG( (boulders.vgrade_range_min + boulders.vgrade_range_max) / 2.0))"
    ))
  end

  def most_frequented_gym(days_ago: nil)
    return nil unless sessions.any?
    result = sessions.group(:gym_name).order(Arel.sql('COUNT(*) DESC')).count.first

    days_ago.present? ? result.where(
      'created_at > ?', Time.zone.now - days_ago
    ).group(:gym_name).order(Arel.sql('COUNT(*) DESC')).count.first[0] : result[0]
  end

  def sends_by_grade(days_ago: nil)
    result = SessionClimb
      .joins(:boulder)
      .where(user_id: id)
      .where(percent_finished: 100)
    result = result.where("session_climbs.created_at > ?", Time.zone.now - days_ago) if days_ago.present?

    result = result.group("boulders.vgrade_range_max").order("boulders.vgrade_range_max").count
    result.map { |grade, count| { vgrade: grade, sends: count } }
  end
end
