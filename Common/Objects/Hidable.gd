extends StaticBody2D

var isActive : bool = false
func _ready() -> void:
	await get_tree().process_frame
	UnlimitedRulebook.player.machine.StateChanged.connect(Deactivate)

func Activate():
	UnlimitedRulebook.player.machine.change_state_to("hide")
	collision_layer = 32
	print("HIDDEN")
	isActive = true

func Deactivate():
	if(UnlimitedRulebook.player.machine.get_state()!="hide"):
		collision_layer = 0
		isActive = false

func _input(event: InputEvent) -> void:
	if(isActive):
		if(event.is_action_released("down")):
			UnlimitedRulebook.player.machine.change_state_to("idle")
