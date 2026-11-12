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
  belongs_to :boulder
  belongs_to :user

  has_one_attached :image

  validates :caption, length: { maximum: 100 }
end
