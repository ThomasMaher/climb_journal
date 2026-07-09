class Session < ApplicationRecord
    validates :date, presence: true
    validates :gym_name, presence: true, length: { maximum: 50 }
    validates :notes, length: { maximum: 255 }
end