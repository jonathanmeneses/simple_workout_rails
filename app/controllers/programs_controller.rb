class ProgramsController < ApplicationController
  allow_unauthenticated_access
  
  def index
    @program_types = [
      {
        type: "3-day",
        name: "3-Day Full Body",
        programs: WorkoutProgram.where(program_type: :full_body_3_day)
      },
      {
        type: "4-day", 
        name: "4-Day Upper/Lower",
        programs: WorkoutProgram.where(program_type: :upper_lower_4_day)
      }
    ]
  end

  def show
    @program = WorkoutProgram.find(params[:id])
    @view_mode = params[:view_mode] || "description"
    @selected_cycle = params[:cycle] || @program.workout_cycles.first&.name
    
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
