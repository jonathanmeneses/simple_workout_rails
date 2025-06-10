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
    @selected_cycle = params[:cycle] || @program.workout_cycles.order(:cycle_type).first&.name

    # Handle equipment selection
    @selected_equipment = params[:equipment]&.reject(&:blank?) || []
    @no_equipment = params[:no_equipment] == "1"

    # Store equipment selection in session for persistence
    if params.key?(:equipment) || params.key?(:no_equipment)
      session[:selected_equipment] = @selected_equipment
      session[:no_equipment] = @no_equipment
    else
      @selected_equipment = session[:selected_equipment] || []
      @no_equipment = session[:no_equipment] || false
    end

    # Determine available equipment for exercise filtering
    if @no_equipment
      @available_equipment = [] # No equipment means only exercises with empty equipment_required
    elsif @selected_equipment.any?
      @available_equipment = @selected_equipment
    else
      # Default: all equipment available
      @available_equipment = Exercise::VALID_EQUIPMENT
    end

    # Handle exercise substitutions
    @substitutions = params[:substitutions] || {}
  end
end
