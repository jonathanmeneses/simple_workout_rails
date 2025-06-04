class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :workout_programs, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true
end
