class ProgramsController < ApplicationController
  # Authentication is handled by the concern's default `before_action :require_authentication`
  before_action :set_program, only: [:show, :edit, :update, :destroy]

  def index
    @selected_program_type = params[:program_type] || "3-day" # Or handle differently if no user programs of a type

    user_programs = current_user.workout_programs

    @program_types = [
      {
        type: "3-day",
        name: "3-Day Full Body",
        programs: user_programs.where(program_type: :full_body_3_day)
      },
      {
        type: "4-day",
        name: "4-Day Upper/Lower",
        programs: user_programs.where(program_type: :upper_lower_4_day)
      }
      # Consider adding a category for programs with other program_types or if program_type is nil
    ]
    # Filter to only show types that have programs for the current user or handle empty states in view
    @program_types.select! { |pt| pt[:programs].any? } if user_programs.any?

    # If a specific program type is selected but has no programs, maybe reset or provide feedback
    if @program_types.none? { |pt| pt[:type] == @selected_program_type && pt[:programs].any? }
      active_type = @program_types.find { |pt| pt[:programs].any? }
      @selected_program_type = active_type ? active_type[:type] : nil # select first active type or nil
    end
  end

  def show
    # @program is set by set_program
    valid_modes = %w[description program schedule]
    @view_mode = valid_modes.include?(params[:view_mode]) ? params[:view_mode] : "description"
    @selected_cycle = params[:cycle] || @program.workout_cycles.first&.name
  end

  def new
    @program = current_user.workout_programs.build
  end

  def create
    @program = current_user.workout_programs.build(program_params)
    if @program.save
      respond_to do |format|
        format.html { redirect_to program_path(@program), notice: 'Workout program was successfully created.' }
        format.turbo_stream { flash.now[:notice] = 'Workout program was successfully created.' }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @program is set by set_program
  end

  def update
    # @program is set by set_program
    if @program.update(program_params)
      redirect_to program_path(@program), notice: 'Workout program was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # @program is set by set_program
    @program.destroy
    respond_to do |format|
      format.html { redirect_to programs_path, notice: 'Workout program was successfully destroyed.' }
      format.turbo_stream { flash.now[:notice] = 'Workout program was successfully destroyed.' }
    end
  end

  private

  def set_program
    @program = current_user.workout_programs.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    # Handle case where program doesn't exist or doesn't belong to user
    # Log this attempt, maybe?
    redirect_to programs_path, alert: "Workout program not found or access denied."
  end

  def program_params
    params.require(:workout_program).permit(:name, :description, :program_type)
    # Note: user_id is not permitted as it's set via current_user
  end
end
