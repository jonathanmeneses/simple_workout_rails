class ProgramService
  def self.find_cycle(program_id, cycle_name)
    program = WorkoutProgram.find(program_id)
    program.workout_cycles.find_by(name: cycle_name)
  end

  def self.find_session(program_id, cycle_name, session_name)
    cycle = find_cycle(program_id, cycle_name)
    return nil unless cycle

    cycle.workout_sessions.find_by(name: session_name)
  end
end
