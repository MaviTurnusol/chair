extends State

func PhysicsProcess(_delta):
	if(stateOwner.velocity.x!=0):
		stateOwner.velocity.x = lerp(stateOwner.velocity.x, -stateOwner.dir*stateOwner.speed, 0.1)
	stateOwner.move_and_slide()
	
	#	stateOwner.get_node("Marker2D").scale.x = -1*sign(stateOwner.get_global_mouse_position().x - stateOwner.global_position.x)

func End():
	stateOwner.dir = -stateOwner.dir
