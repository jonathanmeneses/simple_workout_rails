module ProgramsHelper
  def substitution_options(original_exercise, user_equipment = nil, original_name = nil)
    # Use service to get substitutes
    substitutes = ExerciseSubstitutionService.call(original_exercise, user_equipment: user_equipment)

    # Build options array
    display_name = original_name || original_exercise.name
    options = [[ display_name, display_name ]]

    substitutes.each do |substitute|
      label = substitute.name

      # Add movement pattern indicator if different
      if substitute.movement_pattern.name != original_exercise.movement_pattern.name
        label += " (#{substitute.movement_pattern.name.humanize})"
      end

      options << [ label, substitute.name ]
    end

    options
  end
  
  def substitution_indicator_class(current_selection, original_name)
    if current_selection != original_name
      "text-sm border-0 bg-transparent text-blue-600 font-semibold hover:text-blue-800 focus:ring-0 cursor-pointer"
    else
      "text-sm border-0 bg-transparent text-gray-900 hover:text-blue-600 focus:ring-0 cursor-pointer"
    end
  end
end
