extends Node2D

var mod_stack
var ik_mod
var initial_pos : Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_pos = position
	mod_stack = $Skeleton2D.get_modification_stack()
	ik_mod = mod_stack.get_modification(0) as SkeletonModification2DTwoBoneIK
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	$Targets/target.global_position = get_global_mouse_position()
	
	if get_local_mouse_position().x < 0:
		ik_mod.flip_bend_direction = false
		position = initial_pos + Vector2(12, 0)
		$Sprites/IkForeArm.flip_v = true
		$Sprites/IkUpperArm.flip_v = true
	else:
		ik_mod.flip_bend_direction = true
		position = initial_pos
		$Sprites/IkForeArm.flip_v = false
		$Sprites/IkUpperArm.flip_v = false
	pass
