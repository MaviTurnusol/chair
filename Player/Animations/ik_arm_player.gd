extends Node2D

var mod_stack
var ik_mod
var initial_pos : Vector2

enum STATES {FOLLOW_CURSOR, LARP_CURSOR, STATIC}
var state = STATES.FOLLOW_CURSOR : set = set_state

func set_state(value):
	if value == state:
		return
	if state == STATES.STATIC:
		value = STATES.LARP_CURSOR
	if value == STATES.LARP_CURSOR:
		$Targets/target.position = Vector2(3, 30)
		$larpTimer.start()
	state = value

func _ready() -> void:
	initial_pos = position
	mod_stack = $Skeleton2D.get_modification_stack()
	ik_mod = mod_stack.get_modification(0) as SkeletonModification2DTwoBoneIK
	
	visibility_changed.connect(_on_visibility_changed)

func _physics_process(_delta: float) -> void:
	if state == STATES.FOLLOW_CURSOR:
		$Targets/target.global_position = get_global_mouse_position()
	elif state == STATES.LARP_CURSOR:
		$Targets/target.global_position = lerp($Targets/target.global_position, 
		get_global_mouse_position(), 0.1)
		print("larp larp larp sahuuuur")
	
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


func _on_larp_timer_timeout() -> void:
	state = STATES.FOLLOW_CURSOR

func _on_visibility_changed() -> void:
	if visible:
		state = STATES.LARP_CURSOR
