class ProgramsController < ApplicationController
  allow_unauthenticated_access
  def index
  end

  def show
    demo_programs = Rails.application.config_for(:demo_programs)
    @program = demo_programs[params[:id]] || demo_programs["1"]
  end
end
