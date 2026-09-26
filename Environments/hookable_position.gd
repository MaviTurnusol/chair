extends Area2D

var mouseInArea = false
@export var cShape : CollisionShape2D
var hookEndPos := Vector2.ZERO

var objectHook = null

# 0 < x < 100   ==>   No Curves
# 100 < x < 200   ==>   1 Curve
# 200 < x < 300   ==>   2 Curves
# 300 < x < 400   ==>   3 Curves
# 400 < x < 500   ==>   4 Curves

func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	if mouseInArea && Input.is_action_just_pressed("interact"):
		if UnlimitedRulebook.player.machine.get_state() != "hook":
			UnlimitedRulebook.player.machine.change_state_to("hook")
			var object_hook = load("res://Player/object_hook.tscn").instantiate()
			#object_hook.global_position = UnlimitedRulebook.player.global_position + Vector2(0, -50)
			#hookEndPos = global_position - UnlimitedRulebook.player.global_position - Vector2(0, -50)
			hookEndPos = UnlimitedRulebook.player.global_position - global_position + Vector2(0, -50)
			object_hook.global_position = global_position
			object_hook.points[1] = Vector2.ZERO
			
			var newPoints : PackedVector2Array
			newPoints.resize(2)
			newPoints[0] = Vector2.ZERO
			newPoints[1] = hookEndPos
			UnlimitedRulebook.currentScene.add_child(object_hook)
			var twink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
			twink.tween_property(object_hook, "points", newPoints, 0.15)
			
			var hookLen = global_position.distance_to(hookEndPos)
			var direction = hookEndPos - object_hook.points[0]
			var hookAngle = direction.angle()
			$arrow.rotation = hookAngle
			print(hookAngle)
			var curveCount = 0
			#if hookLen > 4:
				#curveCount = 4
				#object_hook.points[4] = hookEndPos
				#objectHook.points[3] = hookLen/5
			
			
			#object_hook.points[1] = global_position - UnlimitedRulebook.player.global_position - Vector2(0, -50)
			hookEndPos = object_hook.points[1]
			#await get_tree().create_timer(0.15).timeout
			#print(hookLen)
			
			objectHook = object_hook
			objectHook.EndPos = global_position - Vector2(0, -50)
	pass

func _on_area_entered(_area: Area2D) -> void:
	mouseInArea = true

func _on_area_exited(_area: Area2D) -> void:
	mouseInArea = false
