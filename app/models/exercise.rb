class Exercise < ApplicationRecord
  belongs_to :movement_pattern
  validates :name, :movement_pattern, presence: true
end
