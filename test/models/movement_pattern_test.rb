require "test_helper"

class MovementPatternTest < ActiveSupport::TestCase
  test "is valid with a name" do
    pattern = MovementPattern.new(name: "Hinge")
    assert pattern.valid?
  end

  test "is invalid without a name" do
    pattern = MovementPattern.new
    assert_not pattern.valid?
  end
end
