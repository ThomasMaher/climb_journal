require 'rails_helper'

RSpec.describe UserBoulderDataService do
  before do
    user = create :user, username: 'Dayan', password: 'password'
    session1 = create :session, user: user, gym_name: 'Bbump', date: Time.zone.today - 1.day
    session2 = create :session, user: user, gym_name: 'Bbump', date: Time.zone.today
    b1 = create(
      :boulder,
      created_by: user,
      nickname: 'slab',
      vgrade_range_min: 5,
      vgrade_range_max: 5
    )
    create(
      :session_climb,
      user: user,
      session: session1,
      boulder: b1,
      attempts: 3,
      percent_finished: 80
    )
    create(
      :session_climb,
      user: user,
      session: session2,
      boulder: b1,
      attempts: 3,
      percent_finished: 100
    )
  end
  let(:boulder) { Boulder.last }
  let(:user) { User.last }

  describe '#run' do
    it 'returns basic data about the boulder' do
      results = UserBoulderDataService.new(boulder.id, user.id).run

      expect(results[:total_sessions]).to eq 2
      expect(results[:current_progress]).to eq 100
      expect(results[:total_attempts]).to eq 6
      expect(results[:date_completed].to_s).to eq Time.zone.today.to_s
      expect(results[:date_completed].to_s).to eq Time.zone.today.to_s
    end
  end
end
