require 'rails_helper'

RSpec.describe SessionsController, type: :request do
    before do
        Session.create(date: Date.today - 1.year, gym_name: 'Vital', user_id: 1)
        Session.create(date: Date.today, gym_name: 'Vital', user_id: 1)
    end

    describe '#index' do
        it 'provides a list of all sessions' do
            sessions = Session.all

            get '/users/1/sessions'
            expect(response.status).to eq 200
            expect(JSON.parse(response.body).length).to eq sessions.length
        end
    end

    describe '#show' do
        it 'returns data for a single specified session' do
            session = Session.last

            get "/users/1/sessions/#{session.id}", params: {  format: 'json' }
            expect(response.status).to eq 200
            result = JSON.parse(response.body)
            expect(result['gym_name']).to eq session.gym_name
            expect(result['id']).to eq session.id
            expect(result['date']).to eq session.date.to_s
            expect(result['notes']).to eq session.notes
        end

        it 'returns not found if the session does not exist by id' do
            get "/users/1/sessions/-10"
            expect(response.status).to eq 404
        end
    end

    describe '#create' do
        it 'creates a new session with valid params' do
            date = Date.today - 1.day
            gym_name = 'Vital'
            note = 'Fun session'
            session_params = {session: {date: date, gym_name: gym_name, notes: note } }

            post '/users/1/sessions', params: session_params
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)['date']).to eq date.to_s
            expect(JSON.parse(response.body)['gym_name']).to eq gym_name
            expect(JSON.parse(response.body)['notes']).to eq note
        end

        it 'validates fields' do
            session_params = {session: {date: nil, gym_name: 'Vital'*50, notes: 'Fun'*250 } }

            post '/users/1/sessions', params: session_params
            expect(response.status).to eq 422
            errors = JSON.parse(response.body)['errors']
            expect(errors['date']).to include('Date can\'t be blank')
            expect(errors['gym_name']).to include('Gym name is too long (maximum is 50 characters)')
            expect(errors['notes']).to include('Notes is too long (maximum is 255 characters)')
        end
    end
end