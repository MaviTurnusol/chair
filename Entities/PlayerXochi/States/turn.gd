extends State

func PhysicsProcess(_delta):
	if(stateOwner.velocity.x!=0):
		stateOwner.velocity.x = lerp(stateOwner.velocity.x, -stateOwner.dir*stateOwner.speed, 0.1)
	else:
		stateOwner.velocity.x = lerp(0.0,-stateOwner.dir*50,50*_delta)
	stateOwner.move_and_slide()
	
	#	stateOwner.get_node("Marker2D").scale.x = -1*sign(stateOwner.get_global_mouse_position().x - stateOwner.global_position.x)

func End():
	stateOwner.dir = -stateOwner.dir
