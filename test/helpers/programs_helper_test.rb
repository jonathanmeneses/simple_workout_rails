require "test_helper"

class ProgramsHelperTest < ActionView::TestCase
  fixtures :movement_patterns, :exercises

  test "substitution_options should return array of options" do
    original_exercise = exercises(:bench_press)
    substitutes = [ exercises(:overhead_press) ]
    name = original_exercise.name

    options = substitution_options(original_exercise, substitutes, name)

    assert_instance_of Array, options
    assert_not_empty options

    # First option should be the original exercise
    assert_equal original_exercise.name, options.first.first
  end

  test "substitution_options should handle empty substitutes" do
    exercise = exercises(:bench_press)
    options = substitution_options(exercise, [], exercise.name)

    assert_instance_of Array, options
    assert_equal 1, options.length  # Should only contain original exercise
    assert_equal exercise.name, options.first.first
  end

  test "substitution_options should use custom original name" do
    exercise = exercises(:bench_press)
    custom_name = "Custom Bench Press"
    options = substitution_options(exercise, [], custom_name)

    assert_equal custom_name, options.first.first
  end

  test "substitution_indicator_class should return appropriate classes" do
    original_name = "Bench Press"

    # When selection matches original
    original_class = substitution_indicator_class(original_name, original_name)
    assert_includes original_class, "text-gray-900"

    # When selection is different
    substitute_class = substitution_indicator_class("Push-up", original_name)
    assert_includes substitute_class, "text-blue-600"
  end
end
