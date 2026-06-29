extends Area2D

@export var cutscene_state : State

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact"):
		var actionables = get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			
			if cutscene_state:
				cutscene_state.actionable = actionables[0]
