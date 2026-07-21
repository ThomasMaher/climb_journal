json.overall do
  json.total_sessions @user.total_sessions
  json.highest_grade @user.highest_grade
  json.avg_grade_climbed @user.avg_grade_climbed
  json.most_frequented_gym @user.most_frequented_gym
  json.sends_by_grade @user.sends_by_grade
end

json.past_month do
  json.total_sessions @user.total_sessions(30)
  json.highest_grade @user.highest_grade(30)
  json.avg_grade_climbed @user.avg_grade_climbed(30)
  json.most_frequented_gym @user.most_frequented_gym(30)
  json.sends_by_grade @user.sends_by_grade(30)
end