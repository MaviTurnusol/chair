extends CanvasLayer

@onready var mouser := $mouser

enum MODES {DEFAULT, CLICKED, ATTACK_DEF, ATTACK_CLK}
var cursor_mode = MODES.DEFAULT : set = set_mode

func set_mode(value):
	if value == cursor_mode:
		return
	if value in [MODES.ATTACK_CLK, MODES.ATTACK_DEF] && cursor_mode in [MODES.DEFAULT, MODES.CLICKED]:
		$mouser/sprite.play("attack")
	if cursor_mode in [MODES.ATTACK_DEF, MODES.ATTACK_CLK] && value in [MODES.DEFAULT, MODES.CLICKED]:
		$mouser/sprite.play_backwards("attack")
	cursor_mode = value

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	pass

func _process(_delta: float) -> void:
	mouser.global_position = mouser.get_global_mouse_position()
	
	match cursor_mode:
		MODES.DEFAULT:
			if Input.is_action_just_pressed("Click"):
				mouser.global_rotation_degrees = -20.0
				cursor_mode = MODES.CLICKED
		MODES.CLICKED:
			if Input.is_action_just_released("Click"):
				mouser.global_rotation_degrees = 0.0
				cursor_mode = MODES.DEFAULT
		MODES.ATTACK_DEF:
			if Input.is_action_just_pressed("Click"):
				mouser.global_rotation_degrees = -20.0
				cursor_mode = MODES.ATTACK_CLK
		MODES.ATTACK_CLK:
			if Input.is_action_just_released("Click"):
				mouser.global_rotation_degrees = 0.0
				cursor_mode = MODES.ATTACK_DEF

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion || event is InputEventMouseButton:
		$RestTimer.start()
		mouser.modulate = Color.WHITE


func _on_rest_timer_timeout() -> void:
	var twink = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	twink.tween_property(mouser, "modulate", Color.TRANSPARENT, 0.1)
	#mouser.visible = false
