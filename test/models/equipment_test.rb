require "test_helper"

class EquipmentTest < ActiveSupport::TestCase
  test "is valid with a name" do
    equipment = Equipment.new(name: "Barbell")
    assert equipment.valid?
  end

  test "is invalid without a name" do
    equipment = Equipment.new
    assert_not equipment.valid?
  end
end
