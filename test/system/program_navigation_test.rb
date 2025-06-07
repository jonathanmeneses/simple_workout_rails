require "application_system_test_case"

class ProgramNavigationTest < ApplicationSystemTestCase
  test "user can browse workout programs" do
    visit programs_path

    # Should see the main page
    assert_text "Workout Program Generator"
    assert_text "3-Day Full Body"
    assert_text "4-Day Upper/Lower"

    # Click on a program
    program = workout_programs(:three_day_full_body)
    click_on program.name

    # Should navigate to program page
    assert_current_path program_path(program)
    assert_text program.name
  end

  test "user can switch between view modes" do
    program = workout_programs(:three_day_full_body)
    visit program_path(program)

    # Should start in description mode
    assert_text "Program Overview"
    assert_selector "[data-view-mode='description'].border-blue-500"

    # Click Program tab
    click_button "Program"

    # Should switch to program view
    assert_text "Select Cycle:"
    assert_selector "select[data-programs-target='cycleSelector']"
    assert_selector "[data-view-mode='program'].border-blue-500"

    # Click Schedule tab
    click_button "Schedule"

    # Should switch to schedule view
    assert_text "Weekly Schedule"
    assert_selector "[data-view-mode='schedule'].border-blue-500"

    # Click back to Description
    click_button "Description"

    # Should return to description view
    assert_text "Program Overview"
    assert_selector "[data-view-mode='description'].border-blue-500"
  end

  test "user can select different training cycles" do
    program = workout_programs(:three_day_full_body)
    visit program_path(program, view_mode: "program")

    # Should be in program view with cycle selector
    assert_text "Select Cycle:"
    assert_selector "select[data-programs-target='cycleSelector']"

    # Should show default cycle content
    assert_text "Base Strength"

    # Select a different cycle
    select "Unilateral & Core", from: "cycleSelector"

    # Should navigate to new cycle
    assert_text "Unilateral & Core"
    assert_current_path program_path(program, view_mode: "program", cycle: "Unilateral & Core")
  end

  test "user can see exercise details in program view" do
    program = workout_programs(:three_day_full_body)
    visit program_path(program, view_mode: "program")

    # Should see exercise information
    assert_text "Back Squat"
    assert_text "2×5"
    assert_text "Main"
    assert_text "Accessory"

    # Should see workout session names
    assert_text "FB-A: Squat Focus"
    assert_text "FB-B: Power & Deadlift"
  end

  test "user can see schedule overview in schedule view" do
    program = workout_programs(:three_day_full_body)
    visit program_path(program, view_mode: "schedule")

    # Should see schedule layout
    assert_text "Weekly Schedule"
    assert_text "Cycle 1: Base Strength"
    assert_text "FB-A: Squat Focus"
    assert_text "exercises"
  end

  test "navigation preserves state across page loads" do
    program = workout_programs(:three_day_full_body)
    cycle = workout_cycles(:base_strength)

    # Visit specific view mode and cycle
    visit program_path(program, view_mode: "program", cycle: cycle.name)

    # Should preserve the state
    assert_selector "[data-view-mode='program'].border-blue-500"
    assert_text cycle.name
    assert_text cycle.description

    # Navigate to home and back
    visit programs_path
    assert_text "Workout Program Generator"

    visit program_path(program, view_mode: "program", cycle: cycle.name)

    # Should still preserve the state
    assert_selector "[data-view-mode='program'].border-blue-500"
    assert_text cycle.name
  end

  test "responsive design works on mobile viewport" do
    program = workout_programs(:three_day_full_body)

    # Set mobile viewport
    page.driver.browser.manage.window.resize_to(375, 667)

    visit program_path(program)

    # Should still show all content
    assert_text program.name
    assert_text "Description"
    assert_text "Program"
    assert_text "Schedule"

    # Should be able to switch modes
    click_button "Program"
    assert_text "Select Cycle:"
  end

  test "back button works correctly" do
    program = workout_programs(:three_day_full_body)
    visit programs_path

    # Navigate to program
    click_on program.name
    assert_current_path program_path(program)

    # Use back button link
    click_link "← Back to Programs"
    assert_current_path programs_path
    assert_text "Workout Program Generator"
  end

  test "URL sharing works for specific views" do
    program = workout_programs(:three_day_full_body)
    cycle = workout_cycles(:base_strength)

    # Visit specific URL that someone might share
    visit program_path(program, view_mode: "program", cycle: cycle.name)

    # Should load directly to correct state
    assert_selector "[data-view-mode='program'].border-blue-500"
    assert_text cycle.name
    assert_text "Select Cycle:"
  end
end
