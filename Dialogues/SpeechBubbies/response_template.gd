extends Button

func _ready() -> void:
	spawn()

func _process(delta: float) -> void:
	if !$Timer.is_stopped():
		position.y += delta * 400 * $Timer.time_left

func spawn():
	self_modulate = Color.TRANSPARENT
	$Timer.start(1.0)
	var fadeTwink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	fadeTwink.tween_property(self, "self_modulate", Color.WHITE, 2.0)


func _on_timer_timeout() -> void:
	pass # Replace with function body.
