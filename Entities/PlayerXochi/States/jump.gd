extends State

func Start():
	stateOwner.velocity.y = stateOwner.jumpVelocity
	if Input.is_action_pressed("right"):
		stateOwner.velocity.x = stateOwner.speed * 1.6
		stateOwner.flip("right")
	elif Input.is_action_pressed("left"):
		stateOwner.velocity.x = -stateOwner.speed * 1.6
		stateOwner.flip("left")
	else:
		stateOwner.velocity.x = stateOwner.dir * stateOwner.speed * 1.6

func PhysicsProcess(_delta):
	stateOwner.move_and_slide()
	if stateOwner.velocity.y > 0:
		machine.change_state_to("fall")
