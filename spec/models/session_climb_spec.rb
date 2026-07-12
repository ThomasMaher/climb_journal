require 'rails_helper'

RSpec.describe SessionClimb, type: :model do
  describe 'before validations' do
    it 'sets attempt and percent_finished value if not entered by the user' do
      session = Session.create(date: Date.today, gym_name: 'Vital')
      boulder = Boulder.create(
        vgrade_range_min: 2,
        vgrade_range_max: 3,
        self_grade: 3,
        boulder_type: 'Indoor',
        nickname: 'Tracy'
      )

      session = SessionClimb.new(session_id: session.id, boulder_id: boulder.id)
      session.valid?

      expect(session.percent_finished).to eq 0
      expect(session.attempts).to eq 0
    end
  end

  describe 'validations' do
    it 'validates join uniqueness of boulder and session id' do
      session = Session.create(date: Date.today, gym_name: 'Vital')
      boulder = Boulder.create(
        vgrade_range_min: 2,
        vgrade_range_max: 3,
        self_grade: 3,
        boulder_type: 'Indoor',
        nickname: 'Tracy'
      )

      SessionClimb.create(session_id: session.id, boulder_id: boulder.id)
      session = SessionClimb.new(session_id: session.id, boulder_id: boulder.id)

      valid = session.valid?
      expect(valid).to be false
      expect(session.errors.full_messages).to include("Boulder has already been added to this session")
    end
  end
end