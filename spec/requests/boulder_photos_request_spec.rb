require 'rails_helper'

RSpec.describe "Boulder Photos", type: :request do
  describe '#create' do
    before do
      user = create :user, first_name: 'Yufei', last_name: 'Pan', password: 'password'
      create :boulder, created_by: user, nickname: 'Test Boulder'
      post '/login', params: { user: { username: user.username, password: 'password' } }
    end
    let(:boulder) { Boulder.last }

    it 'creates a valid boulder' do
      initial_count = BoulderPhoto.count
      post "/boulders/#{boulder.id}/boulder_photos", params: {
        format: :json,
        boulder_photo: {
          caption: 'Test 1',
          image: fixture_file_upload('spec/fixtures/files/boulder1.jpg', 'image/jpeg')
        }
      }

      expect(response).to have_http_status(:created)
      expect(BoulderPhoto.last.caption).to eq('Test 1')
      expect(BoulderPhoto.last.image).to be_attached
      expect(BoulderPhoto.count).to eq(initial_count + 1)
    end

    it 'responds with 404 if boulder does not exist' do
      post "/boulders/-2/boulder_photos", params: {
        format: :json,
        boulder_photo: {
          caption: 'Test 1',
          image: fixture_file_upload('spec/fixtures/files/boulder1.jpg', 'image/jpeg')
        }
      }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to eq( "error" => "No boulder with that id" )
    end

    it 'responds with 401 if user did not create the associated boulder' do
      new_user = create :user, password: 'password'
      other_boulder = create :boulder, created_by: new_user, nickname: 'V2'

      post "/boulders/#{other_boulder.id}/boulder_photos", params: {
        format: :json,
        boulder_photo: {
          caption: 'Test 1',
          image: fixture_file_upload('spec/fixtures/files/boulder1.jpg', 'image/jpeg')
        }
      }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to eq( "error" => "You are not authorized to add images to this boulder" )
    end

    it 'responds with 403 with errors if photo is invalid' do
      post "/boulders/#{boulder.id}/boulder_photos", params: {
        format: :json,
        boulder_photo: { caption: 'Test 1'*100 }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']['caption']).to include( "Caption is too long (maximum is 100 characters)" )
      expect(JSON.parse(response.body)['errors']['image']).to include( "Image can't be blank" )
    end
  end
end
