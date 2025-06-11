# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Starting database seeding..."

# Import all exercises, equipment, and movement patterns
ExerciseImporter.import_all

puts "Seeded #{Equipment.count} equipment items, #{MovementPattern.count} movement patterns, #{Exercise.count} exercises..."

# Seed demo workout programs
ProgramSeeder.seed_demo_programs

if Rails.env.development?
  # Create a development user
  User.find_or_create_by!(email_address: "user@example.com") do |user|
    user.password = "password"
    user.password_confirmation = "password"
  end
  puts "Created development user: user@example.com / password"
end

puts "✅ Database seeding complete!"
puts "📊 Final counts: #{Exercise.count} exercises, #{WorkoutProgram.count} programs, #{WorkoutSession.count} sessions"
