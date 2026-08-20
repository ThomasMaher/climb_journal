require 'rails_helper'

RSpec.describe SessionsController, type: :request do
    before do
        user = create :user, password: 'password'
        post '/login', params: { user: { username: user.username, password: 'password' } }
        Session.create(date: Date.today - 1.year, gym_name: 'Vital', user_id: user.id)
        Session.create(date: Date.today, gym_name: 'Vital', user_id: user.id)
    end
    let(:user) { User.last }

    describe '#index' do
        it 'provides a list of all sessions' do
            sessions = user.sessions

            get "/sessions"
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).length).to eq sessions.length
        end

        it 'returns unauthorized if user is not logged in' do
            delete '/logout'

            get '/sessions'
            expect(response.status).to eq 401
        end
    end

    describe '#show' do
        it 'returns data for a single specified session' do
            session = Session.last

            get "/sessions/#{session.id}", params: {  format: 'json' }
            expect(response.status).to eq 200
            result = JSON.parse(response.body)
            expect(result['gym_name']).to eq session.gym_name
            expect(result['id']).to eq session.id
            expect(result['date']).to eq session.date.to_s
            expect(result['notes']).to eq session.notes
        end

        it 'includes warmup and non-warmup session climbs in the response' do
            session = Session.last
            b1 = create :boulder, boulder_type: 'indoor', nickname: 'test1', created_by_id: user.id
            b2 = create :boulder, boulder_type: 'indoor', nickname: 'test2', created_by_id: user.id
            create :session_climb, :warmup, session: session, user: user, boulder: b1
            create :session_climb, session: session, user: user, boulder: b2, warmup: false

            get "/sessions/#{session.id}", params: {  format: 'json' }
            expect(response.status).to eq 200
            result = JSON.parse(response.body)
            expect(result.keys).to include 'warmup'
            expect(result.keys).to include 'not_warmup'
            expect(result['warmup'].first['warmup']).to eq true
            expect(result['not_warmup'].first['warmup']).to eq false
        end

        it 'returns not found if the session does not exist by id' do
            get "/sessions/-10"
            expect(response.status).to eq 404
        end

        it 'returns unauthorized if user is not logged in' do
            session = Session.last
            delete '/logout'

            get "/sessions/#{session.id}", params: {  format: 'json' }
            expect(response.status).to eq 401
        end
    end

    describe '#create' do
        it 'creates a new session with valid params' do
            date = Date.today - 1.day
            gym_name = 'Vital'
            note = 'Fun session'
            session_params = { session: { date: date, gym_name: gym_name, notes: note } }

            post "/sessions", params: session_params
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)['date']).to eq date.to_s
            expect(JSON.parse(response.body)['gym_name']).to eq gym_name
            expect(JSON.parse(response.body)['notes']).to eq note
        end

        it 'validates fields' do
            session_params = { session: { date: nil, gym_name: 'Vital'*50, notes: 'Fun'*250 } }

            post "/sessions", params: session_params
            expect(response.status).to eq 422
            errors = JSON.parse(response.body)['errors']
            expect(errors['date']).to include('Date can\'t be blank')
            expect(errors['gym_name']).to include('Gym name is too long (maximum is 50 characters)')
            expect(errors['notes']).to include('Notes is too long (maximum is 255 characters)')
        end
    end

    describe '#destroy' do
        it 'returns not found if the session does not exist' do
            delete "/sessions/-10"
            expect(response.status).to eq 404
        end

        it 'return unauthorized if session is not associated with user' do
            other_user = create :user
            other_user_session = create :session, user: other_user

            delete "/sessions/#{other_user_session.id}", params: { format: :json }

            expect(response.status).to eq 401
        end

        it 'successfully destroys the session' do
            session_count = Session.count
            session = user.sessions.first

            delete "/sessions/#{session.id}", params: { format: :json }

            expect(response.status).to eq 200
            expect(Session.count).to eq session_count - 1
        end
    end

    describe '#session_stats' do
        it 'returns not found if session does not exist' do
            get "/sessions/-1", params: { format: :json }

            expect(response.status).to eq 404
        end

        it 'returns basic data for the user session' do
            session = Session.last
            b1 = create :boulder, boulder_type: 'Indoor', nickname: 'test1', created_by_id: user.id
            b2 = create :boulder, boulder_type: 'Indoor', nickname: 'test2', created_by_id: user.id
            create :session_climb, session: session, user: user, boulder: b1, warmup: false
            create :session_climb, session: session, user: user, boulder: b2, warmup: false

            get "/sessions/#{session.id}/session_stats", params: { format: :json }

            expect(response.status).to eq 200
            results = JSON.parse(response.body, symbolize_names: true)
            expect(results[:total_boulders]).to eq 2
            expect(results[:highest_grade_sent]).to eq 3
        end
    end
end
