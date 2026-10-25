extends State

var startVel

func Start():
	startVel = stateOwner.velocity.x
	pass
	
func PhysicsProcess(_delta):
	stateOwner.move_and_slide()
	stateOwner.velocity.x = lerp(stateOwner.velocity.x, startVel/2, 0.1)
