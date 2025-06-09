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
  end

  test "show with program view mode" do
    program = workout_programs(:three_day_full_body)
    get program_url(program, view_mode: "program")
    assert_response :success
    # test that cycle form exists
    assert_select "form#cycle_form"
    assert_select "form#cycle_form select[name='cycle']"
    # Test navigation tabs - "Program" should be active (blue border)
    assert_select "a", text: "Program", class: "border-blue-500"
  end

  test "show with description view mode" do
    program = workout_programs(:three_day_full_body)
    get program_url(program, view_mode: "description")
    assert_response :success

    # Test navigation tabs - "Description" should be active (blue border)
    assert_select "a", text: "Description", count: 1, class: "border-blue-500"

    # Test navigation tabs - "Program" and "Schedule" should be inactive (transparent border)
    assert_select "a", text: "Program", count: 1, class: "border-transparent"
    assert_select "a", text: "Schedule", count: 1, class: "border-transparent"
  end

  test "show with schedule view mode" do
    program = workout_programs(:three_day_full_body)
    get program_url(program, view_mode: "schedule")
    assert_response :success
    assert_match "Weekly Schedule", response.body
    # Test navigation tabs - "Schedule" should be active (blue border)
    assert_select "a", text: "Schedule", count: 1, class: "border-blue-500"

    # Test navigation tabs - "Description" and "Program" should be inactive (transparent border)
    assert_select "a", text: "Description", count: 1, class: "border-transparent"
    assert_select "a", text: "Program", count: 1, class: "border-transparent"
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
    get program_url(999999)
    assert_response :not_found
  end

  test "show displays exercises for program view mode" do
    program = workout_programs(:three_day_full_body)
    cycle = workout_cycles(:base_strength)
    get program_url(program, view_mode: "program", cycle: cycle.name)
    assert_response :success

    # Should show exercises from the specified cycle
    assert_match "Back Squat", response.body
    assert_match "Overhead Press (OHP)", response.body
  end

  test "show defaults to first cycle when no cycle specified" do
    program = workout_programs(:three_day_full_body)
    get program_url(program, view_mode: "program")
    assert_response :success

    # Should default to Base Strength cycle (cycle_type: 0)
    assert_match "Base Strength", response.body
    assert_select "select[name='cycle'] option[selected='selected']", text: "Base Strength"

    # Should show exercises from the default cycle
    assert_match "Back Squat", response.body
    assert_match "Overhead Press (OHP)", response.body
  end

  test "show displays workout sessions for schedule view mode" do
    program = workout_programs(:three_day_full_body)
    get program_url(program, view_mode: "schedule")
    assert_response :success

    # Should show workout sessions (& may be HTML-encoded as &amp;)
    assert_match "FB-A: Squat Focus", response.body
    assert_match "FB-B: Power", response.body
    assert_match "Deadlift", response.body
  end

  test "equipment selection with no equipment option" do
    program = workout_programs(:three_day_full_body)

    # Test with no equipment selected (default: all equipment)
    get program_url(program, view_mode: "program")
    assert_response :success
    assert_match "All equipment available", response.body

    # Test with no_equipment=1 (bodyweight only)
    get program_url(program, view_mode: "program", no_equipment: "1")
    assert_response :success
    assert_match "Bodyweight exercises only", response.body

    # Test with specific equipment selected
    get program_url(program, view_mode: "program", equipment: [ "barbell", "dumbbells" ])
    assert_response :success
    assert_match "Selected: Barbell, Dumbbells", response.body
  end
end
