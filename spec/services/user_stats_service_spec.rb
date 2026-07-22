require 'rails_helper'

RSpec.describe 'UserStatsService' do
  before do
    user = User.create(first_name: 'Mejdi')
    session1 = Session.create(gym_name: 'GP81', date: Time.zone.today - 1.day, user_id: user.id)
    session2 = Session.create(gym_name: 'Vital', date: Time.zone.today - 31.days, user_id: user.id)
    b = Boulder.create(vgrade_range_min: 14, vgrade_range_max: 15)
    SessionClimb.create(
      user_id: user.id,
      session_id: session1.id,
      boulder_id: b.id,
      percent_finished: 100,
      attempts: 1
    )

    b2 = Boulder.create(vgrade_range_min: 16, vgrade_range_max: 17)
    SessionClimb.create(
      user_id: user.id,
      session_id: session2.id,
      boulder_id: b2.id,
      percent_finished: 100,
      attempts: 1
    )

    b3 = Boulder.create(vgrade_range_min: 16, vgrade_range_max: 17)
    SessionClimb.create(
      user_id: user.id,
      session_id: session1.id,
      boulder_id: b3.id,
      percent_finished: 25,
      attempts: 10
    )
  end
  let(:service) { UserStatsService.new(User.last) }
  let(:session1) { Session.last }

  describe '#total_sessions' do
    it 'produces count of all existing sessions for a user' do
      expect(service.run[:total_sessions]).to eq 2
    end

    it 'produces count of sessions within a time period for a user' do
      expect(service.run(days_ago: 30)[:total_sessions]).to eq 1
    end
  end

  describe '#highest_grade_sent' do
    it 'produces highest grade sent based on max vgrade range' do
      expect(service.run[:highest_grade]).to eq 17
    end

    it 'produces highest grade sent within a period based on max vgrade range' do
      expect(service.run(days_ago: 30)[:highest_grade]).to eq 15
    end

    it 'excludes climbs that have not been sent' do
      expect(service.run[:highest_grade]).to eq 15
    end
  end
end