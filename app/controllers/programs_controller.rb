class ProgramsController < ApplicationController
  allow_unauthenticated_access
  def index
  end

  def show
    demo_programs = Rails.application.config_for(:demo_programs)["programs"]
    # debugger
    Rails.logger.debug "Program: #{demo_programs.inspect}"
    @program = demo_programs[params[:id]] || demo_programs[1]
    # debugger
    Rails.logger.debug "Program: #{@program.inspect}"
  end
end
