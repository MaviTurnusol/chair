extends Node2D

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	rotation = -get_parent().global_rotation
