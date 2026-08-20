require 'rails_helper'

RSpec.describe SessionClimbsController, type: :request do
  before do
    create :user, username: 'meichi', password: 'narasaki'
    user = create :user, username: 'tomoa', password: 'narasaki'
    session = create :session, user_id: user.id
    boulder = create :boulder, nickname: 'boulderboy', created_by_id: user.id
    create :session_climb, user: user, session: session, boulder: boulder
  end
  let(:session_climb) { SessionClimb.last }

  describe '#show' do
    it 'returns 401 if user not logged in' do
      get "/session_climbs/#{session_climb.id}", params: { format: :json }

      expect(response.status).to eq 401
    end

    it 'does not allow other users to view data' do
      post '/login', params: { user: { username: 'meichi', password: 'narasaki' } }
      get "/session_climbs/#{session_climb.id}", params: { format: :json }

      expect(response.status).to eq 401
    end

    it 'returns not found if session climb not found' do
      post '/login', params: { user: { username: 'tomoa', password: 'narasaki' } }
      get "/session_climbs/5000", params: { format: :json }

      expect(response.status).to eq 404
    end

    it 'returns info on climb and boulder' do
      post '/login', params: { user: { username: 'tomoa', password: 'narasaki' } }
      get "/session_climbs/#{session_climb.id}", params: { format: :json }

      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['id']).to eq session_climb.id
      expect(JSON.parse(response.body)['boulder_id']).to eq session_climb.boulder&.id
    end
  end

  describe '#destroy' do
    it 'returns 401 if user not logged in' do
      delete "/session_climbs/#{session_climb.id}", params: { format: :json }

      expect(response.status).to eq 401
    end

    it 'does not allow other users to delete data' do
      post '/login', params: { user: { username: 'meichi', password: 'narasaki' } }
      delete "/session_climbs/#{session_climb.id}", params: { format: :json }

      expect(response.status).to eq 401
    end

    it 'returns not found if session climb not found' do
      post '/login', params: { user: { username: 'tomoa', password: 'narasaki' } }
      delete "/session_climbs/5000", params: { format: :json }

      expect(response.status).to eq 404
    end

    it 'returns info on climb and boulder' do
      post '/login', params: { user: { username: 'tomoa', password: 'narasaki' } }
      delete "/session_climbs/#{session_climb.id}", params: { format: :json }

      expect(response.status).to eq 303
    end
  end
end