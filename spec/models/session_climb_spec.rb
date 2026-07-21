# == Schema Information
#
# Table name: session_climbs
#
#  id               :integer          not null, primary key
#  session_id       :integer          not null
#  boulder_id       :integer          not null
#  user_id          :integer          not null
#  attempts         :integer
#  percent_finished :integer          not null
#  notes            :text(65535)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_session_climbs_on_attempts                   (attempts)
#  index_session_climbs_on_boulder_id                 (boulder_id)
#  index_session_climbs_on_percent_finished           (percent_finished)
#  index_session_climbs_on_session_id_and_boulder_id  (session_id,boulder_id) UNIQUE
#  index_session_climbs_on_user_id                    (user_id)
#

require 'rails_helper'

RSpec.describe SessionClimb, type: :model do
  describe 'before validations' do
    it 'sets attempt and percent_finished value if not entered by the user' do
      user = User.create()
      session = Session.create(date: Date.today, gym_name: 'Vital', user_id: user.id)
      boulder = Boulder.create(
        vgrade_range_min: 2,
        vgrade_range_max: 3,
        self_grade: 3,
        boulder_type: 'Indoor',
        nickname: 'Tracy'
      )

      session = SessionClimb.new(session_id: session.id, boulder_id: boulder.id, user_id: user.id)
      session.valid?

      expect(session.percent_finished).to eq 0
      expect(session.attempts).to eq 0
    end
  end

  describe 'validations' do
    it 'validates join uniqueness of boulder and session id' do
      user = User.create()
      session = Session.create(date: Date.today, gym_name: 'Vital', user_id: user.id)
      boulder = Boulder.create(
        vgrade_range_min: 2,
        vgrade_range_max: 3,
        self_grade: 3,
        boulder_type: 'Indoor',
        nickname: 'Tracy'
      )

      SessionClimb.create(session_id: session.id, boulder_id: boulder.id, user_id: user.id)
      session = SessionClimb.new(session_id: session.id, boulder_id: boulder.id, user_id: user.id)

      valid = session.valid?
      expect(valid).to be false
      expect(session.errors.full_messages).to include("Boulder has already been added to this session")
    end
  end
end
