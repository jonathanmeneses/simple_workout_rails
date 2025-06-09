# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Seed Equipment
EQUIPMENT_LIST = [
  "barbell", "rack", "kettlebell", "dumbbell", "heel_wedge", "bodyweight", "TRX_or_rail", "trap_bar", "bench", "adjustable_bench", "pull_up_bar", "dip_bars", "rings", "landmine", "plate", "rings_or_TRX", "medicine_ball"
]

equipment_records = {}
EQUIPMENT_LIST.each do |name|
  equipment_records[name] = Equipment.find_or_create_by!(name: name)
end

# Seed Movement Patterns
MOVEMENT_PATTERNS = [
  "squat", "hinge", "horizontal_push", "vertical_push", "vertical_pull", "horizontal_pull", "lunge", "carry", "core", "core_rotation"
]

movement_pattern_records = {}
MOVEMENT_PATTERNS.each do |name|
  movement_pattern_records[name] = MovementPattern.find_or_create_by!(name: name)
end

# Load unified exercise database with comprehensive attributes
puts "Loading unified exercise database..."
require_relative 'import_unified_exercise_database'

puts "Seeded #{Equipment.count} equipment items, #{MovementPattern.count} movement patterns, #{Exercise.count} exercises..."

# Clear existing workout program data only (keep exercises, equipment, movement patterns)
WorkoutExercise.destroy_all
WorkoutSession.destroy_all
WorkoutCycle.destroy_all
WorkoutProgram.destroy_all

puts "Cleared existing workout program data..."

# Load demo programs from hardcoded data (no more YAML dependency)
require_relative 'hardcoded_program_data'
demo_data = HARDCODED_PROGRAM_DATA
puts "Demo data loaded from hardcoded source"

demo_data.each do |program_id, program_data|
  next unless program_data.is_a?(Hash) && program_data[:name]

  puts "Creating program: #{program_data[:name]}"

  # Create the workout program
  workout_program = WorkoutProgram.create!(
    name: program_data[:name],
    description: program_data[:description],
    program_type: program_data[:name].include?("3-Day") ? :full_body_3_day : :upper_lower_4_day
  )

  # Create cycles for this program
  program_data[:cycles]&.each do |cycle_data|
    puts "  Creating cycle: #{cycle_data[:name]}"

    workout_cycle = workout_program.workout_cycles.create!(
      name: cycle_data[:name],
      description: cycle_data[:description]
    )

    # Create sessions for this cycle
    cycle_data[:days]&.each do |day_data|
      puts "    Creating session: #{day_data[:title]}"

      workout_session = workout_cycle.workout_sessions.create!(
        name: day_data[:title]
      )

      # Create exercises for this session
      day_data[:exercises]&.each_with_index do |exercise_data, index|
        # Find or create the exercise
        exercise = Exercise.find_or_create_by!(name: exercise_data[:name]) do |ex|
          # Use a default movement pattern if not found in existing data
          ex.movement_pattern = MovementPattern.first
          ex.description = exercise_data[:notes]
        end

        # Create the workout exercise
        # Store sets/reps in notes if they're strings, otherwise use the integer columns
        sets_value = exercise_data[:sets].is_a?(Integer) ? exercise_data[:sets] : nil
        reps_value = exercise_data[:reps].is_a?(Integer) ? exercise_data[:reps] : nil

        # Build comprehensive notes that include sets/reps info plus original notes
        notes_parts = []
        notes_parts << exercise_data[:sets] if exercise_data[:sets].present?
        notes_parts << exercise_data[:reps] if exercise_data[:reps].present?
        notes_parts << exercise_data[:notes] if exercise_data[:notes].present?

        workout_session.workout_exercises.create!(
          exercise: exercise,
          sets: sets_value,
          reps: reps_value,
          notes: notes_parts.join(" - "),
          order_position: index + 1,
          exercise_type: exercise_data[:type] == "main" ? :main : :accessory
        )
      end
    end
  end
end

puts "Seeded #{WorkoutProgram.count} workout programs"
puts "Seeded #{WorkoutCycle.count} workout cycles"
puts "Seeded #{WorkoutSession.count} workout sessions"
puts "Seeded #{WorkoutExercise.count} workout exercises"
