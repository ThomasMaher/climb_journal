# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  first_name      :string
#  last_name       :string
#  username        :string(40)       not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :session_climbs, dependent: :destroy
  has_many :boulders, through: :session_climbs
  has_many :created_boulders, foreign_key: :created_by_id, class_name: 'Boulder'

  validates :username, presence: true, uniqueness: true
end
