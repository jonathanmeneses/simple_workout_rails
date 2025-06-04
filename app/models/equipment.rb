class Equipment < ApplicationRecord
  has_many :exercise_equipments, dependent: :destroy
  has_many :exercises, through: :exercise_equipments

  validates :name, presence: true
end
