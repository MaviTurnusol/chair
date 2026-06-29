extends Camera2D


@export var target: Node2D

var current_target: Vector2
@export var disabled = false

func _ready() -> void:
	UnlimitedRulebook.cam = self
	global_position = target.global_position
	reset_smoothing.call_deferred()


func _process(_delta: float) -> void:
	if !disabled:
		if current_target != Vector2(0, 0):
			global_position = current_target
		elif target:
			global_position = target.global_position


func world_position_to_screen_position(world_position: Vector2) -> Vector2:
	return (world_position - get_screen_center_position()) * zoom + get_viewport().get_visible_rect().size / 2
