json.overall do
  json.total_sessions @user.total_sessions
  json.highest_grade @user.highest_grade
  json.avg_grade_sent @user.avg_sent_grade
  json.most_frequented_gym @user.most_frequented_gym.present? ? @user.most_frequented_gym[0] : ''
  json.sends_by_grade @user.sends_by_grade
end

json.past_month do
  json.total_sessions @user.total_sessions(days_ago: 30)
  json.highest_grade @user.highest_grade(days_ago: 30)
  json.avg_grade_sent @user.avg_sent_grade(days_ago: 30)
  json.most_frequented_gym @user.most_frequented_gym(days_ago: 30).present? ? @user.most_frequented_gym(days_ago: 30)[0] : ''
  json.sends_by_grade @user.sends_by_grade(days_ago: 30)
end