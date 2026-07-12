require 'rails_helper'

RSpec.describe BouldersController, type: :request do
  describe '#show' do
    it 'returns data for a single specified boulder' do
      boulder = Boulder.create(
        vgrade_range_min: 2,
        vgrade_range_max: 3,
        self_grade: 3,
        boulder_type: 'Indoor',
        nickname: 'Tracy'
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
        indoor: true
      } }

      expect(response.status).to eq 201
      expect(JSON.parse(response.body)['vgrade_range_min']).to eq 2
      expect(JSON.parse(response.body)['vgrade_range_max']).to eq 3
    end

    it 'accepts nested attributes for a session_climb' do
      session = Session.create(date: Date.today, gym_name: 'Vital')
      post "/boulders", params: { boulder: {
        vgrade_range_min: 2,
        vgrade_range_max: 3,
        indoor: true,
        session_climbs_attributes: [ {
                                      session_id: session.id,
                                      attempts: 5,
                                      percent_finished: 100,
                                      notes: 'Sick boulder'
                                    } ]
      } }
      boulder = Boulder.last
      session_climb = SessionClimb.last

      expect(response.status).to eq 201
      expect(JSON.parse(response.body)['vgrade_range_min']).to eq 2
      expect(JSON.parse(response.body)['vgrade_range_max']).to eq 3
      expect(session_climb.boulder_id).to eq boulder.id
      expect(session_climb.session_id).to eq session.id
    end

    it 'does not allow two session climbs (session and boulder id must be unique together)' do
      session = Session.create(date: Date.today, gym_name: 'Vital')
      post "/boulders", params: { boulder: {
        vgrade_range_min: 2,
        vgrade_range_max: 3,
        indoor: true,
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
                                     }]
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
      expect(errors['rating']).to include('Rating must be greater than or equal to 1')
      expect(errors['notes']).to include('Notes is too long (maximum is 400 characters)')
      expect(errors['boulder_type']).to include('Boulder type is not included in the list')
    end

    it 'validates nested attributes for a session_climb' do
      post "/boulders", params: { boulder: {
        vgrade_range_min: 2,
        vgrade_range_max: 3,
        indoor: true,
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
end