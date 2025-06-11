# Add missing equipment from updated_equipments.yml
require_relative '../../config/environment'

puts "🔧 Adding missing equipment from updated_equipments.yml..."

# Equipment names from updated_equipments.yml (just the essential new ones for now)
missing_equipment_names = [
  "dumbbells",
  "cable_machine", 
  "commercial_gym_machines",
  "resistance_bands",
  "ghd",
  "glute_ham_raise",
  "nordic_bench",
  "reverse_hyper",
  "back_extension_bench"
]

created_count = 0
updated_count = 0

missing_equipment_names.each do |equipment_name|
  equipment = Equipment.find_or_initialize_by(name: equipment_name)
  
  if equipment.persisted?
    puts "  ✓ #{equipment_name} already exists"
  else
    if equipment.save
      puts "  ✅ Created: #{equipment_name}"
      created_count += 1
    else
      puts "  ❌ Failed to create #{equipment_name}: #{equipment.errors.full_messages.join(', ')}"
    end
  end
end

puts
puts "🎯 Summary:"
puts "  Created: #{created_count} new equipment items"
puts "  Total equipment: #{Equipment.count}"
puts "✅ Equipment table updated successfully!"