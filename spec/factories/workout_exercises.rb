FactoryBot.define do
  factory :workout_exercise do
    workout_session { nil }
    exercise { nil }
    sets { 1 }
    reps { 1 }
    notes { "MyString" }
    order_position { 1 }
  end
end
