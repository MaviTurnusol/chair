extends State

func PhysicsProcess(_delta):
	stateOwner.move_and_slide()
	if stateOwner.is_on_floor():
		if stateOwner.velocity.y > 10:
			machine.change_state_to("fallRecovery")
		else:
			machine.change_state_to("fallRecovery")
