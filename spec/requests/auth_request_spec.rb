require 'rails_helper'

RSpec.describe AuthController, type: :request do
  before do
    create :user, username: 'Toby', password: 'secret'
  end
  let(:toby) { User.last }

  describe '#user_status' do
    it 'returns current user' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(toby)

      get '/user_status'
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['username']).to eq 'Toby'
    end

    it 'returns unauthorized when no user is logged in' do
      get '/user_status'

      expect(response.status).to eq 401
    end
  end

  describe '#create' do
    it 'authenticates user and starts a session' do
      post '/login', params: {
        user: { username: 'Toby', password_digest: 'secret' },
        format: :json
      }

      expect(response.status).to eq 201
      expect(session[:user_id]).to eq toby.id
      expect(JSON.parse(response.body)['username']).to eq 'Toby'
    end

    it 'returns an error if password and username do not match' do
      post '/login', params: { user: { username: 'Toby', password_digest: '123' } }

      expect(response.status).to eq 401
      expect(session[:user_id]).to be nil
      expect(JSON.parse(response.body)['error']).to eq 'Invalid username or password'
    end
  end

  describe '#destroy' do
    it 'ends the session' do
      post '/login', params: { user: { username: 'Toby', password_digest: 'secret' } }

      expect(response.status).to eq 201
      expect(session[:user_id]).to eq toby.id

      delete '/logout'

      expect(session[:user_id]).to be nil
      expect(response.status).to eq 204
    end
  end
end