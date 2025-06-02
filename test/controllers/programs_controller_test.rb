require "test_helper"

class ProgramsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get programs_url
    assert_response :success
    assert_select "h1", text: /Workout Program Generator/
    assert_select "[data-tab]", count: 2  # 3-day and 4-day tabs
  end

  test "index shows program types" do
    get programs_url
    assert_match "3-Day Full Body", response.body
    assert_match "4-Day Upper/Lower", response.body
  end

  test "should get show" do
    program = workout_programs(:three_day_full_body)
    get program_url(program)
    assert_response :success
    assert_select "h1", text: program.name
  end

  test "show defaults to description view mode" do
    program = workout_programs(:three_day_full_body)
    get program_url(program)
    assert_response :success
    assert_match "Program Overview", response.body
    assert_select "[data-view-mode='description']" do |elements|
      assert elements.any? { |el| el["class"].include?("border-blue-500") }
    end
  end

  test "show with program view mode" do
    program = workout_programs(:three_day_full_body)
    get program_url(program, view_mode: "program")
    assert_response :success
    assert_select "select[data-programs-target='cycleSelector']"
    assert_select "[data-view-mode='program']" do |elements|
      assert elements.any? { |el| el["class"].include?("border-blue-500") }
    end
  end

  test "show with schedule view mode" do
    program = workout_programs(:three_day_full_body)
    get program_url(program, view_mode: "schedule")
    assert_response :success
    assert_match "Weekly Schedule", response.body
    assert_select "[data-view-mode='schedule']" do |elements|
      assert elements.any? { |el| el["class"].include?("border-blue-500") }
    end
  end

  test "show with specific cycle" do
    program = workout_programs(:three_day_full_body)
    cycle = workout_cycles(:base_strength)
    get program_url(program, view_mode: "program", cycle: cycle.name)
    assert_response :success
    assert_match cycle.name, response.body
    assert_match cycle.description, response.body
  end

  test "show with invalid program id" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get program_url(id: 999999)
    end
  end

  test "show displays exercises for program view mode" do
    program = workout_programs(:three_day_full_body)
    get program_url(program, view_mode: "program")
    assert_response :success
    
    # Should show exercises from the first cycle by default
    assert_match "Back Squat", response.body
    assert_match "Overhead Press", response.body
  end

  test "show displays workout sessions for schedule view mode" do
    program = workout_programs(:three_day_full_body)
    get program_url(program, view_mode: "schedule")
    assert_response :success
    
    # Should show workout sessions
    assert_match "FB-A: Squat Focus", response.body
    assert_match "FB-B: Power & Deadlift", response.body
  end
end