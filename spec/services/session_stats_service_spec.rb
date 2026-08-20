require 'rails_helper'

RSpec.describe SessionStatsService do
  before do
    user = create :user, username: 'Dayan', password: 'password'
    session = create :session, user: user, gym_name: 'Bbump'
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
      session: session,
      boulder: b1,
      percent_finished: 100
    )
  end
  let(:session) { Session.last }

  # TODO: write alternate cases for each method
  describe '#run' do
    it 'returns basic data about the session' do
      results = SessionStatsService.new(session).run

      expect(results[:total_boulders]).to eq 1
      expect(results[:highest_grade_sent]).to eq 5
      expect(results[:sends_by_grade]).to eq [ { vgrade: 5, sends: 1 } ]
    end
  end
end
