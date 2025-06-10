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

  # Auto-substitution helpers
  def get_display_exercise_name(workout_exercise, available_equipment)
    # Check if manual substitution is active
    manual_substitute = params[:substitutions]&.dig(workout_exercise.exercise.id.to_s)
    return manual_substitute if manual_substitute.present?

    # Check if auto-substitution is needed
    if workout_exercise.needs_auto_substitution?(available_equipment)
      auto_substitute = workout_exercise.get_auto_substitute(available_equipment)
      return auto_substitute.name if auto_substitute
    end

    # Return original exercise name
    workout_exercise.exercise.name
  end

  def exercise_substitution_status(workout_exercise, available_equipment)
    manual_substitute = params[:substitutions]&.dig(workout_exercise.exercise.id.to_s)

    if manual_substitute.present?
      return { type: :manual, original: workout_exercise.exercise.name, current: manual_substitute }
    end

    if workout_exercise.needs_auto_substitution?(available_equipment)
      auto_substitute = workout_exercise.get_auto_substitute(available_equipment)
      if auto_substitute
        return {
          type: :auto,
          original: workout_exercise.exercise.name,
          current: auto_substitute.name,
          reason: "Equipment unavailable"
        }
      else
        return {
          type: :unavailable,
          original: workout_exercise.exercise.name,
          current: workout_exercise.exercise.name,
          reason: "No suitable alternative found"
        }
      end
    end

    { type: :none, original: workout_exercise.exercise.name, current: workout_exercise.exercise.name }
  end
end
