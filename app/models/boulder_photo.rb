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

class BoulderPhoto < ApplicationRecord
  IMAGE_MAX = 5

  belongs_to :boulder
  belongs_to :user

  has_one_attached :image

  validates :caption, length: { maximum: 100 }
  validates :image,
            attached: true,
            content_type: {
              in: ['image/png', 'image/jpg', 'image/jpeg', 'image/webp'],
              spoofing_protection: true
            },
            size: { less_than_or_equal_to: 10.megabytes }
  validate :count_per_boulder


  private

  def count_per_boulder
    images_for_boulder = BoulderPhoto.where(boulder_id: boulder_id, user_id: user_id).count
    return if images_for_boulder < IMAGE_MAX

    errors.add(:boulder_id, "Max of #{IMAGE_MAX} images allowed.")
  end
end
