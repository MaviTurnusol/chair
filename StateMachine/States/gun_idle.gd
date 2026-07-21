extends State

func PhysicsProcess(_delta):
	var dir = Input.get_axis("left", "right")
	if dir:
		machine.change_state_to("gunWalk")
	else:
		stateOwner.velocity.x = lerp(stateOwner.velocity.x, 0.0, 0.1)
		
	if abs(stateOwner.velocity.x) < 10:
		stateOwner.anima.play(animName)
	stateOwner.move_and_slide()
	
	stateOwner.get_node("Marker2D").scale.x = sign(stateOwner.get_global_mouse_position().x - stateOwner.global_position.x)
