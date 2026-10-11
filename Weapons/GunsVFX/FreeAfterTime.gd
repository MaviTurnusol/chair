extends RigidBody2D

@export var Duration : float = 3

func _ready() -> void:
	await get_tree().create_timer(Duration).timeout
	queue_free()
