extends Node

#not used anyeway

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UnlimitedRulebook.cam.zoom = Vector2.ONE * 1.5
	UnlimitedRulebook.cam.position_smoothing_enabled = false
