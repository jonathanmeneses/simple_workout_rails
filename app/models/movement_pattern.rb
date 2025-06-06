class MovementPattern < ApplicationRecord
  has_many :exercises, dependent: :destroy
  
  validates :name, presence: true
end
