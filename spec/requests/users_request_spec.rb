require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe '#home_stats' do
    # This is more of a feature test and doesn't belong here - need to find the right place for this test
    it 'produces expected stats for user' do
      user = User.create(first_name: 'Camilla', last_name: 'Moroni')
      session1 = Session.create(user: user, gym_name: 'Vital', date: Time.zone.now - 31.days)
      session2 = Session.create(user: user, gym_name: 'Vital', date: Time.zone.now - 10.days)
      boulder1 = Boulder.create(
        vgrade_range_min: 2,
        vgrade_range_max: 4,
        self_grade: 3,
        incline: 10,
        boulder_type: 'Indoor',
        nickname: 'burp'
      )
      boulder2 = Boulder.create(
        vgrade_range_min: 5,
        vgrade_range_max: 5,
        self_grade: 5,
        incline: 30,
        boulder_type: 'Indoor',
        nickname: 'hiccup'
      )
      s = SessionClimb.create(session_id: session1.id, user_id: user.id, boulder_id: boulder1.id, attempts: 1, percent_finished: 100)
      SessionClimb.create(session_id: session1.id, user_id: user.id, boulder_id: boulder2.id, attempts: 10, percent_finished: 80)
      SessionClimb.create(session_id: session2.id, user_id: user.id, boulder_id: boulder2.id, attempts: 15, percent_finished: 100)

      get "/users/#{user.id}/home_stats", params: { format: :json }
      result = JSON.parse(response.body)
      overall = result['overall']
      past_month = result['past_month']

      expect(response.status).to eq 200
      expect(overall['total_sessions']).to eq 2
      expect(overall['highest_grade']).to eq 5
      expect(past_month['total_sessions']).to eq 1
      expect(past_month['highest_grade']).to eq 4
    end
  end
end