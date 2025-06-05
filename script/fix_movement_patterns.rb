#!/usr/bin/env ruby
require_relative '../config/environment'

# Fix incorrect movement pattern assignments
vertical_push = MovementPattern.find_by(name: 'vertical_push')
hinge = MovementPattern.find_by(name: 'hinge')
horizontal_pull = MovementPattern.find_by(name: 'horizontal_pull')
core_pattern = MovementPattern.find_by(name: 'core')

fixes = [
  ['Overhead Press (OHP)', vertical_push],
  ['Push-Press', vertical_push],
  ['Ring Row', horizontal_pull],
  ['GHD Sit-up', core_pattern],
  ['Pallof Press', core_pattern]
]

puts "Fixing movement pattern assignments..."

fixes.each do |name, pattern|
  exercise = Exercise.find_by(name: name)
  if exercise && pattern
    old_pattern = exercise.movement_pattern.name
    exercise.update_columns(movement_pattern_id: pattern.id)
    puts "✅ Fixed #{name}: #{old_pattern} → #{pattern.name}"
  else
    puts "❌ Could not find: #{name} or pattern"
  end
end

puts "\nTesting OHP substitutes after fix:"
ohp = Exercise.find_by(name: 'Overhead Press (OHP)')
if ohp
  subs = ohp.find_substitutes(['dumbbells'], 5)
  if subs.any?
    subs.each { |sub| puts "  - #{sub.name} (#{sub.movement_pattern.name})" }
  else
    puts "  No substitutes found (expected - need more vertical push exercises with attributes)"
  end
end