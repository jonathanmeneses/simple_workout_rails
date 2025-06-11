class ProgramSeeder
  def self.seed_demo_programs
    # Clear existing workout program data only (keep exercises, equipment, movement patterns)
    WorkoutExercise.destroy_all
    WorkoutSession.destroy_all
    WorkoutCycle.destroy_all
    WorkoutProgram.destroy_all

    puts "Cleared existing workout program data..."

    # Load demo programs from hardcoded data
    require_relative '../../db/scripts/hardcoded_program_data'
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

            sets_val = exercise_data[:sets]
            reps_val = exercise_data[:reps]

            # Parse integer if possible, else nil
            sets_int = sets_val.to_s[/\d+/]&.to_i
            reps_int = reps_val.to_s[/\d+/]&.to_i

            # Use the helper from your WorkoutExercise model
            set_type_val = WorkoutExercise.guess_set_type!(sets_val, reps_val, exercise_data[:notes])

            workout_session.workout_exercises.create!(
              exercise: exercise,
              sets: sets_int.presence, # nil if not an integer
              reps: reps_int.presence, # nil if not an integer
              set_type: set_type_val,
              notes: exercise_data[:notes],
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
  end
end