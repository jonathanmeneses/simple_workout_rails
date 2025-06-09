require "test_helper"

class ProgramsTest < ActionDispatch::IntegrationTest
  test "GET /programs returns http success" do
    get "/programs"
    assert_response :success
  end

  test "program index shows both program types" do
    get "/programs"
    assert_response :success

    # Check for 3-day program
    # Note - Hardcoding in the controller, need to move to using the actual program name
    assert_match "3-Day Full Body", response.body

    # Check for 4-day program
    # Note - Hardcoding in the controller, need to move to using the actual program name
    assert_match "4-Day Upper/Lower", response.body
  end

  test "can navigate to specific program" do
    program = workout_programs(:three_day_full_body)
    get "/programs/#{program.id}"
    assert_response :success
    assert_match program.name, response.body
  end

  test "view mode switching workflow" do
    program = workout_programs(:three_day_full_body)

    # Start with description mode (default)
    get "/programs/#{program.id}"
    assert_response :success
    assert_match "Program Overview", response.body

    # Switch to program mode
    get "/programs/#{program.id}?view_mode=program"
    assert_response :success
    assert_match "Select Cycle:", response.body
    assert_select "select[data-action='change->form#autoSubmit']"

    # Switch to schedule mode
    get "/programs/#{program.id}?view_mode=schedule"
    assert_response :success
    assert_match "Weekly Schedule", response.body
  end

  test "cycle selection workflow" do
    program = workout_programs(:three_day_full_body)
    cycle = workout_cycles(:base_strength)

    # Get program view with specific cycle
    get "/programs/#{program.id}?view_mode=program&cycle=#{CGI.escape(cycle.name)}"
    assert_response :success

    # Should show the selected cycle
    assert_match cycle.name, response.body
    assert_match cycle.description, response.body

    # Should show exercises from that cycle
    assert_match "Back Squat", response.body
  end

  test "exercise display in program view" do
    program = workout_programs(:three_day_full_body)
    get "/programs/#{program.id}?view_mode=program"
    assert_response :success

    # Should show workout exercises
    assert_match "Back Squat", response.body
    assert_match "2×5", response.body
    assert_match "Main", response.body
    assert_match "Accessory", response.body
  end

  test "session display in schedule view" do
    program = workout_programs(:three_day_full_body)
    get "/programs/#{program.id}?view_mode=schedule"
    assert_response :success

    # Should show workout sessions (account for HTML encoding)
    assert_match "FB-A: Squat Focus", response.body
    assert_match(/FB-B: Power &(amp;|&) Deadlift/, response.body)
    assert_match "exercises", response.body
  end

  test "invalid view mode defaults to description" do
    program = workout_programs(:three_day_full_body)
    get "/programs/#{program.id}?view_mode=invalid"
    assert_response :success

    # Should show description content since invalid mode defaults to description
    assert_match "Program Overview", response.body
  end

  test "navigation preserves URL parameters" do
    program = workout_programs(:three_day_full_body)
    cycle = workout_cycles(:base_strength)

    # Visit with specific parameters
    get "/programs/#{program.id}?view_mode=program&cycle=#{CGI.escape(cycle.name)}"
    assert_response :success

    # Check that the program view mode tab is active (has border-blue-500 class)
    assert_select "a[href*='view_mode=program']" do |elements|
      assert elements.any? { |el| el["class"].include?("border-blue-500") }
    end

    # Check that the cycle selector exists and has the correct selected value
    assert_select "select[name='cycle']" do |elements|
      assert elements.any? { |select|
        select.css("option[selected]").any? { |opt| opt["value"] == cycle.name }
      }
    end
  end

  test "responsive navigation between all view modes" do
    program = workout_programs(:three_day_full_body)

    # Test each view mode
    [ "description", "program", "schedule" ].each do |mode|
      get "/programs/#{program.id}?view_mode=#{mode}"
      assert_response :success

      # Verify the correct tab is active (check for partial href match since program mode includes cycle)
      assert_select "a[href*='view_mode=#{mode}']" do |elements|
        assert elements.any? { |el| el["class"].include?("border-blue-500") }
      end
    end
  end
end
