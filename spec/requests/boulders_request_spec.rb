require 'rails_helper'

RSpec.describe BouldersController, type: :request do
  before do
    user = create :user, password: 'password'
    post '/login', params: { user: { username: user.username, password: 'password' } }
  end
  let(:user) { User.last }

  describe '#show' do
    it 'returns data for a single specified boulder' do
      boulder = Boulder.create(
        vgrade_range_min: 2,
        vgrade_range_max: 3,
        self_grade: 3,
        boulder_type: 'Indoor',
        nickname: 'Tracy',
        created_by_id: user.id
      )

      get "/boulders/#{boulder.id}"
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)).to eq boulder.as_json
    end

    it 'returns not found if the boulder does not exist by id' do
      get "/boulders/0"
      expect(response.status).to eq 404
    end
  end

  describe '#create' do
    it 'create a new boulder with valid params' do
      post "/boulders", params: { boulder: {
        vgrade_range_min: 2,
        vgrade_range_max: 3,
        indoor: true,
        nickname: 'test1',
        created_by_id: user.id
      }, format: :json }

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['vgrade_range_min']).to eq 2
      expect(JSON.parse(response.body)['vgrade_range_max']).to eq 3
    end

    it 'accepts nested attributes for a session_climb' do
      session = Session.create(date: Date.today, gym_name: 'Vital', user_id: user.id)
      post "/boulders", params: { format: :json, boulder: {
        vgrade_range_min: 2,
        vgrade_range_max: 3,
        indoor: true,
        nickname: 'test2',
        created_by_id: user.id,
        session_climbs_attributes: [ {
                                      session_id: session.id,
                                      user_id: user.id,
                                      attempts: 5,
                                      percent_finished: 100,
                                      notes: 'Sick boulder'
                                    } ]
      } }
      session_climb = SessionClimb.last

      expect(response.status).to eq 302
      expect(response).to redirect_to("/session_climbs/#{session_climb&.id}")
    end

    it 'does not allow two session climbs (session and boulder id must be unique together)' do
      session = Session.create(date: Date.today, gym_name: 'Vital', user_id: user.id)
      post "/boulders", params: { boulder: {
        vgrade_range_min: 2,
        vgrade_range_max: 3,
        indoor: true,
        nickname: 'test3',
        created_by_id: user.id,
        session_climbs_attributes: [ {
                                      session_id: session.id,
                                      attempts: 5,
                                      percent_finished: 100,
                                      notes: 'Sick boulder'
                                    },
                                     {
                                       session_id: session.id,
                                       attempts: 10,
                                       percent_finished: 10,
                                       notes: 'Sick boulder'
                                     } ]
      } }

      expect(response.status).to eq 422
      expect(JSON.parse(response.body)['errors']).to include("Only one session climb allowed per session")
    end

    it 'validates fields' do
      boulder_params = { boulder: {
        vgrade_range_max: 2,
        self_grade: -1,
        nickname: 'a'*51,
        rating: 0,
        boulder_type: 'Lead',
        notes: '1'*401
      } }

      post "/boulders", params: boulder_params
      expect(response.status).to eq 422
      errors = JSON.parse(response.body)['errors']
      expect(errors['vgrade_range_min']).to include('Vgrade range min can\'t be blank')
      expect(errors['vgrade_range_max']).to include('Vgrade range max must be greater than or equal to vgrade range minimum')
      expect(errors['nickname']).to include('Nickname is too long (maximum is 50 characters)')
      expect(errors['self_grade']).to include('Self grade must be greater than or equal to 0')
      expect(errors['notes']).to include('Notes is too long (maximum is 400 characters)')
      expect(errors['boulder_type']).to include('Boulder type is not included in the list')
      expect(errors['created_by_id'][0]).to include('must have a creator')
    end

    it 'validates nested attributes for a session_climb' do
      post "/boulders", params: { boulder: {
        vgrade_range_min: 2,
        vgrade_range_max: 3,
        indoor: true,
        nickname: 'test5',
        created_by_id: user.id,
        session_climbs_attributes: [ {
                                       session_id: 100,
                                       attempts: -1,
                                       percent_finished: 200,
                                       notes: 'a'*401
                                     } ]
      } }

      expect(response.status).to eq 422
      errors = JSON.parse(response.body)['errors']
      expect(errors["session_climbs.session"]).to include("Session climbs session must exist")
      expect(errors["session_climbs.attempts"]).to include("Session climbs attempts must be greater than or equal to 0")
      expect(errors["session_climbs.percent_finished"]).to include("Session climbs percent finished must be less than or equal to 100")
      expect(errors["session_climbs.notes"]).to include("Session climbs notes is too long (maximum is 400 characters)")
    end
  end

  describe '#user_boulder_data' do
    it 'returns not found if boulder does not exist' do
      get "/boulders/0"
      expect(response.status).to eq 404
    end

    it 'returns basic data about a user and the boulder' do
      boulder = Boulder.create(
        vgrade_range_min: 2,
        vgrade_range_max: 3,
        self_grade: 3,
        boulder_type: 'Indoor',
        nickname: 'test6',
        created_by_id: user.id
      )

      date = Time.zone.now - 5.days
      [ 2, 2, 4 ].each do |attempts|
        session = create :session, user: user
        create(
          :session_climb,
          session: session,
          user: user,
          boulder: boulder,
          attempts: attempts,
          percent_finished: 100,
          warmup: false
        )
        date += 1.day
      end

      get "/boulders/#{boulder.id}/user_boulder_data"

      expect(response.status).to eq 200
      results = JSON.parse(response.body, symbolize_names: true)
      expect(results[:total_sessions]).to eq 3
      expect(results[:current_progress]).to eq 100
      expect(results[:date_completed].to_s).to eq (Time.zone.now - 1.days).to_date.to_s
      expect(results[:last_date_climbed].to_s).to eq (Time.zone.now - 1.days).to_date.to_s
    end
  end
end
