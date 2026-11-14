extends State

func Start():
	stateOwner.velocity = Vector2.ZERO

func Process(delta):
	stateOwner.move_and_slide()
