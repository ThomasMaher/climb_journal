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
  pending "add some examples to (or delete) #{__FILE__}"
end
