# Clean up exercise equipment according to updated_equipments.yml
require_relative '../../config/environment'

puts "🧹 Cleaning up exercise equipment data according to updated_equipments.yml..."

# Equipment mappings based on updated_equipments.yml
equipment_cleanup = {
  # Remove bodyweight - exercises should have empty equipment array
  'bodyweight' => [],
  # Remove specialty bars - use barbell instead  
  'safety_bar' => ['barbell'],
  # Update old names to standardized names
  'dumbbell' => ['dumbbells'],
  'rack' => ['squat_rack'],
  'rings' => ['rings_or_trx'],
  'TRX_or_rail' => ['rings_or_trx']
}

puts "Processing equipment cleanup mappings..."

updated_count = 0
exercises_processed = 0

Exercise.find_each do |exercise|
  original_equipment = exercise.equipment_required.dup
  new_equipment = original_equipment.dup
  changed = false
  
  # Apply cleanup mappings
  equipment_cleanup.each do |old_equipment, replacement|
    if new_equipment.include?(old_equipment)
      new_equipment.delete(old_equipment)
      new_equipment.concat(replacement) unless replacement.empty?
      changed = true
    end
  end
  
  # Remove duplicates and sort
  new_equipment = new_equipment.uniq.sort
  
  if changed && new_equipment != original_equipment
    exercise.update_column(:equipment_required, new_equipment)
    puts "  ✅ #{exercise.name}: #{original_equipment} → #{new_equipment.any? ? new_equipment : 'bodyweight'}"
    updated_count += 1
  end
  
  exercises_processed += 1
end

puts
puts "🎯 Summary:"
puts "  Processed: #{exercises_processed} exercises"
puts "  Updated: #{updated_count} exercises"
puts "  Equipment cleanup complete!"

# Show some examples of bodyweight exercises
puts
puts "📋 Sample bodyweight exercises (empty equipment):"
Exercise.where(equipment_required: []).limit(5).each do |ex|
  puts "  - #{ex.name}"
end

puts
puts "📋 Sample equipment-based exercises:"
Exercise.where.not(equipment_required: []).limit(5).each do |ex|
  puts "  - #{ex.name}: #{ex.equipment_required.join(', ')}"
end