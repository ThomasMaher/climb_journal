# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  has_many :sessions, dependent: :destroy
  has_many :session_climbs, dependent: :destroy
  has_many :boulders, through: :session_climbs
end
