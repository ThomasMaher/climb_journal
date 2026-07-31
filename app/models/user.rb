# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  first_name :string
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :session_climbs, dependent: :destroy
  has_many :boulders, through: :session_climbs

  validates :username, presence: true, uniqueness: true
end
