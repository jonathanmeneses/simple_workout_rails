module ProgramsHelper
  def substitution_options(original_exercise, substitutes, original_name)
    options = [ [ original_name, original_name ] ]

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

  # Helper methods for button-based substitution interface

  def current_substitution_index(exercise_id, substitutes, original_name)
    current_selection = params[:substitutions]&.dig(exercise_id.to_s) || original_name

    if current_selection == original_name
      0
    else
      substitute_index = substitutes.find_index { |s| s.name == current_selection }
      substitute_index ? substitute_index + 1 : 0
    end
  end

  def exercise_is_substituted?(exercise_id, original_name)
    current_selection = params[:substitutions]&.dig(exercise_id.to_s) || original_name
    current_selection != original_name
  end

  def current_exercise_name(exercise_id, substitutes, original_name)
    current_selection = params[:substitutions]&.dig(exercise_id.to_s) || original_name

    if current_selection == original_name
      original_name
    else
      # Find the substitute by name
      substitute = substitutes.find { |s| s.name == current_selection }
      substitute ? substitute.name : original_name
    end
  end
end
