require 'rails_helper'

RSpec.describe BoulderSearchService do
  describe 'search' do
    before do
      user = create :user, username: 'Erin'
      create(
        :boulder,
        nickname: 'Slabb-y boulder',
        vgrade_range_min: 10,
        vgrade_range_max: 11,
        created_by_id: user.id
      )
      create(
        :boulder,
        nickname: 'Crimp slabb',
        vgrade_range_min: 7,
        vgrade_range_max: 7,
        created_by_id: user.id
      )
      create(
        :boulder,
        nickname: 'Slopers and crimps',
        vgrade_range_min: 6,
        vgrade_range_max: 6,
        created_by_id: user.id
      )
    end

    it 'finds all boulders matching a given name' do
      search_params = { nickname: 'Slab' }
      service = BoulderSearchService.new(search_params)

      names = service.results.map(&:nickname)
      expect(names.count).to eq 2
      expect(names).to include 'Slabb-y boulder'
      expect(names).to include 'Crimp slabb'
    end

    it 'returns results in order of nickname by default' do
      service = BoulderSearchService.new({})

      names = service.results.map(&:nickname)
      expect(names[0]).to include 'Crimp slabb'
      expect(names[1]).to include 'Slabb-y boulder'
      expect(names[2]).to include 'Slopers and crimps'
    end

    it 'can reverse the order' do
      search_params = { order_direction: 'desc' }
      service = BoulderSearchService.new(search_params)

      names = service.results.map(&:nickname)
      expect(names[0]).to include 'Slopers and crimps'
      expect(names[1]).to include 'Slabb-y boulder'
      expect(names[2]).to include 'Crimp slabb'
    end

    it 'can order by other fields' do
      search_params = { order_by: 'vgrade_range_min', order_direction: 'desc' }
      service = BoulderSearchService.new(search_params)

      names = service.results.map(&:nickname)
      expect(names[0]).to include 'Slabb-y boulder'
      expect(names[1]).to include 'Crimp slabb'
      expect(names[2]).to include 'Slopers and crimps'
    end

    it 'finds a boulder equal to a give range' do
      search_params = { grade: 7 }
      service = BoulderSearchService.new(search_params)

      names = service.results.map(&:nickname)
      expect(names.count).to eq 1
      expect(names).to include 'Crimp slabb'
    end

    it 'finds boulers equal to a specific grade when full range is not set' do
      search_params = { min_grade: 7 }
      service = BoulderSearchService.new(search_params)

      names = service.results.map(&:nickname)
      expect(names.count).to eq 1
      expect(names).to include 'Crimp slabb'

      search_params = { max_grade: 7 }
      service = BoulderSearchService.new(search_params)

      names = service.results.map(&:nickname)
      expect(names.count).to eq 1
      expect(names).to include 'Crimp slabb'
    end

    it 'finds boulders within a range' do
      search_params = { min_grade: 7, max_grade: 11 }
      service = BoulderSearchService.new(search_params)

      names = service.results.map(&:nickname)
      expect(names.count).to eq 2
      expect(names).to include 'Slabb-y boulder'
      expect(names).to include 'Crimp slabb'
    end

    it 'finds boulders by type' do
      user = create :user, username: 'Janja'
      create(
        :boulder,
        nickname: 'Outdoor boulder',
        vgrade_range_min: 10,
        vgrade_range_max: 11,
        created_by_id: user.id,
        boulder_type: 'Outdoor'
      )
      search_params = { boulder_type: 'Outdoor' }
      service = BoulderSearchService.new(search_params)

      names = service.results.map(&:nickname)
      expect(names.count).to eq 1
      expect(names).to include 'Outdoor boulder'
    end
  end
end
