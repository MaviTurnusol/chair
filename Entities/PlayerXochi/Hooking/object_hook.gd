extends Line2D

var hooked = false
var EndPos := Vector2.ZERO
var hooking = false

# Store the fully extended points
var original_points : PackedVector2Array

func _ready() -> void:
	await get_tree().create_timer(0.16).timeout
	$speeder.start()
	
	original_points = points.duplicate()
	
	var new_curve = Curve2D.new()
	for c in points:
		new_curve.add_point(c)
		
	$Path2D.curve = new_curve
	$Path2D/PathFollow2D.progress = $Path2D.curve.get_baked_length()
	hooking = true
	
func _process(delta: float) -> void:
	if hooking:
		UnlimitedRulebook.cam.current_target = $Path2D/PathFollow2D/Sprite2D.global_position
		$Path2D/PathFollow2D.progress = clamp($Path2D/PathFollow2D.progress - delta*300.0*(2-$Path2D/PathFollow2D.progress_ratio), 0, $Path2D.curve.get_baked_length())
		
		var ratio = $Path2D/PathFollow2D.progress_ratio
		for i in range(original_points.size()):
			if i != original_points.size()-1:
				set_point_position(i, original_points[i] * ratio)
			else:
				set_point_position(i, $Path2D/PathFollow2D.position)
			
		if $Path2D/PathFollow2D.progress_ratio == 0.0 && !hooked:
			finished()
			UnlimitedRulebook.cam.current_target = Vector2.ZERO
			hooked = true

func finished():
	UnlimitedRulebook.player.global_position = EndPos
	UnlimitedRulebook.hook_ender.emit()
	queue_free()
