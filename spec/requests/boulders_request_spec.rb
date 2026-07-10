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
  end
end