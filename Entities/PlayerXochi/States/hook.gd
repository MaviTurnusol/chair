extends State

var startPosition
var endPosition

func Start():
	stateOwner.velocity = Vector2.ZERO
	stateOwner.set_collisions(false)
	UnlimitedRulebook.hook_ender.connect(HookEnd)
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		pass
	pass

func HookEnd():
	machine.change_state_to("idle")
	
func End():
	stateOwner.set_collisions(true)
	stateOwner.velocity = Vector2.ZERO
	UnlimitedRulebook.hook_ender.disconnect(HookEnd)
