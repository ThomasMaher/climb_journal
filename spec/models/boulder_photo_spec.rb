# == Schema Information
#
# Table name: boulder_photos
#
#  id         :integer          not null, primary key
#  boulder_id :integer          not null
#  user_id    :integer          not null
#  caption    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_boulder_photos_on_boulder_id  (boulder_id)
#  index_boulder_photos_on_user_id     (user_id)
#

require 'rails_helper'

RSpec.describe BoulderPhoto, type: :model do
  describe 'validations' do
    before do
      user = create :user
      create :boulder, nickname: 'boulder1', created_by: user
    end
    let(:user) { User.last }
    let(:boulder) { Boulder.last }

    it 'creates a valid boulder photo' do
      bp = BoulderPhoto.new(
        boulder: boulder,
        user: user,
        image: fixture_file_upload('spec/fixtures/files/boulder1.jpg', 'image/jpeg'),
        caption: 'test caption'
      )

      expect(bp.valid?).to be true
    end

    it 'can create a boulder with no caption' do
      bp = BoulderPhoto.new(
        boulder: boulder,
        user: user,
        image: fixture_file_upload('spec/fixtures/files/boulder1.jpg', 'image/jpeg')
      )

      expect(bp.valid?).to be true
    end

    it 'validates image presence' do
      bp = BoulderPhoto.new(
        boulder: boulder,
        user: user,
        caption: 'test caption'
      )

      valid = bp.valid?
      expect(valid).to eq false
      expect(bp.errors.full_messages).to include("Image can't be blank")
    end

    # should validate size as well - need to find a larger image
    it 'validates caption and content type' do
      bp = BoulderPhoto.new(
        boulder: boulder,
        user: user,
        image: fixture_file_upload('spec/fixtures/files/boulder1.pdf', 'image/jpeg'),
        caption: 'test caption'*100
      )

      valid = bp.valid?
      expect(valid).to eq false
      expect(bp.errors.full_messages).to include("Caption is too long (maximum is 100 characters)")
      expect(bp.errors.full_messages).to include("Image has an invalid content type (authorized content types are PNG, JPG, WEBP)")
    end

    it 'does not allow more than 5 photos per boulder' do
      5.times do
        create(
          :boulder_photo,
          boulder: boulder,
          user: user,
          image: fixture_file_upload('spec/fixtures/files/boulder1.jpg', 'image/jpeg'),
          caption: 'test caption'
        )
      end

      bp = BoulderPhoto.new(
        boulder: boulder,
        user: user,
        image: fixture_file_upload('spec/fixtures/files/boulder1.jpg', 'image/jpeg'),
        caption: 'test caption'
      )
      valid = bp.valid?
      expect(valid).to eq false
      expect(bp.errors.full_messages).to include('Max of 5 images allowed.')
    end
  end
end
