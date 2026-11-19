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
  end
end