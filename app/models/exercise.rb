class Exercise < ApplicationRecord
  belongs_to :movement_pattern

  has_many :exercise_equipments, dependent: :destroy
  has_many :equipment, through: :exercise_equipments

  validates :name, :movement_pattern, presence: true
  validates :category, presence: true # Assuming new 'category' field is mandatory
end
