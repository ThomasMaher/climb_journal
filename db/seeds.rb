# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user = User.create(first_name: 'Tom', last_name: 'Maher')

session1 = Session.create(date: Time.zone.today - 7.days, gym_name: 'Vital', user_id: user.id)
session2 = Session.create(date: Time.zone.today - 2.days, gym_name: 'Vital', user_id: user.id)

b1 = Boulder.create(vgrade_range_min: 6, vgrade_range_max: 7, self_grade: 4, incline: 0, rating: 3, boulder_type: 'Indoor', nickname: 'Yellow-spooky-slab')
b2 = Boulder.create(vgrade_range_min: 2, vgrade_range_max: 3, self_grade: 4, incline: 60, rating: 4, boulder_type: 'Indoor', nickname: 'Flowy-Orange-outdoor-cave')

SessionClimb.create(session_id: session1.id, user_id: user.id, boulder_id: b1.id, attempts: 3, percent_finished: 100, warmup: false)
SessionClimb.create(session_id: session1.id, user_id: user.id, boulder_id: b2.id, attempts: 1, percent_finished: 100, warmup: true)
SessionClimb.create(session_id: session2.id, user_id: user.id, boulder_id: b2.id, attempts: 1, percent_finished: 100, warmup: true)
