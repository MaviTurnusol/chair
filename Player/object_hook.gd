extends Line2D

var hooked = false
var EndPos := Vector2.ZERO
var hooking = false
# 0 < x < 100   ==>   No Curves
# 100 < x < 200   ==>   1 Curve
# 200 < x < 300   ==>   2 Curves
# 300 < x < 400   ==>   3 Curves
# 400 < x < 500   ==>   4 Curves

func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	for c in points:
		$Path2D.curve.add_point(c)
	$Path2D/PathFollow2D.progress = $Path2D.curve.get_baked_length()
	hooking = true
	pass
	
func _process(delta: float) -> void:
	#$Path2D/PathFollow2D.progress_ratio += delta
	if hooking:
		UnlimitedRulebook.cam.current_target = $Path2D/PathFollow2D/Sprite2D.global_position
		$Path2D/PathFollow2D.progress = clamp($Path2D/PathFollow2D.progress - delta*300.0, 0, $Path2D.curve.get_baked_length())
		if $Path2D/PathFollow2D.progress_ratio == 0.0 && !hooked:
			finished()
			UnlimitedRulebook.cam.current_target = Vector2.ZERO
			hooked = true
	pass

func finished():
	UnlimitedRulebook.player.global_position = EndPos
	UnlimitedRulebook.hook_ender.emit()
	queue_free()
