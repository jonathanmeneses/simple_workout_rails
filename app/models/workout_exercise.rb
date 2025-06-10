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
end
