class WorkoutExercise < ApplicationRecord
  belongs_to :workout_session
  belongs_to :exercise

  validates :workout_session, :exercise, presence: true
  validates :order_position, presence: true, numericality: { greater_than: 0 }

  enum :exercise_type, { main: 0, accessory: 1 }

  attribute :set_type, :string, default: "standard"
  enum :set_type, {
    standard: "standard",
    amrap: "amrap",
    cluster: "cluster",
    drop_set: "drop"
  }

  # Helper to auto-detect set_type from string seeds
  def self.guess_set_type!(sets, reps, notes)
    r = reps.to_s.downcase
    n = notes.to_s.downcase

    return "amrap" if r.include?("amrap") || r.include?("+") || n.include?("amrap")
    return "cluster" if n.include?("cluster") || r.include?("cluster")
    return "drop" if n.include?("drop")
    "standard"
  end

  def display_sets_reps
    return "—" if sets.blank? && reps.blank?

    base = "#{sets}×#{reps}" if sets.present? && reps.present?

    case set_type
    when "standard"
      base
    when "amrap"
      base ? "#{base}+" : "AMRAP"
    when "cluster"
      base ? "#{base} cluster" : "Cluster"
    when "drop_set"
      base ? "#{base}→drop" : "Drop set"
    else
      base || notes&.truncate(20) || "—"
    end
  end

  # Check if this exercise needs auto-substitution based on available equipment
  def needs_auto_substitution?(available_equipment)
    # If exercise requires no equipment, it's always available
    return false unless exercise.equipment_required.present?

    # If no equipment is available but exercise requires equipment, substitution is needed
    return true if available_equipment.blank?

    # Check if any required equipment is missing from available equipment
    required_equipment = exercise.equipment_required
    missing_equipment = required_equipment - available_equipment
    missing_equipment.any?
  end

  # Get the best auto-substitute when equipment is unavailable
  def get_auto_substitute(available_equipment)
    return nil unless needs_auto_substitution?(available_equipment)

    # Find the best substitute that can be performed with available equipment
    substitutes = exercise.find_substitutes(available_equipment, 5)

    # Prefer substitutes that can actually be performed with available equipment
    suitable_substitute = substitutes.find do |sub|
      if available_equipment.blank?
        # No equipment available - need bodyweight exercise
        sub.equipment_required.blank?
      else
        # Check if substitute's equipment is subset of available equipment
        sub.equipment_required.blank? || (sub.equipment_required - available_equipment).empty?
      end
    end

    # Fall back to first substitute if no perfectly suitable one found
    suitable_substitute || substitutes.first
  end
end
