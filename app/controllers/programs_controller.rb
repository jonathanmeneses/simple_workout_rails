class ProgramsController < ApplicationController
  allow_unauthenticated_access

  def index
    @selected_program_type = params[:program_type] || "3-day"
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
    valid_modes = %w[description program schedule]
    @view_mode = valid_modes.include?(params[:view_mode]) ? params[:view_mode] : "description"
    @selected_cycle = params[:cycle] || @program.workout_cycles.first&.name

    # Handle equipment selection - default to all equipment if none selected
    @selected_equipment = params[:equipment]&.reject(&:blank?) || []

    # Store equipment in session for persistence across navigation
    session[:selected_equipment] = @selected_equipment if @selected_equipment.any?
    @selected_equipment = session[:selected_equipment] || [] if @selected_equipment.empty?

    # If no equipment selected, assume all equipment is available
    @available_equipment = @selected_equipment.any? ? @selected_equipment : Exercise::VALID_EQUIPMENT

    # Handle exercise substitutions
    @substitutions = params[:substitutions] || {}
  end
end
