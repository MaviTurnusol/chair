extends Area2D

var OldTarget : Node2D
@export var NewTarget : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(BodyEntered)
	body_exited.connect(BodyExited)

func BodyEntered(body):
	if(body == UnlimitedRulebook.player):
		OldTarget = UnlimitedRulebook.cam.target
		UnlimitedRulebook.cam.position_smoothing_enabled = true
		UnlimitedRulebook.cam.position_smoothing_speed = 5
		UnlimitedRulebook.cam.target = NewTarget
func BodyExited(body):
	if(body == UnlimitedRulebook.player):
		UnlimitedRulebook.cam.target = OldTarget
		UnlimitedRulebook.cam.position_smoothing_speed = 25 
		await get_tree().create_timer(0.5).timeout
		if(UnlimitedRulebook.cam.target != NewTarget):
			UnlimitedRulebook.cam.position_smoothing_enabled = false
