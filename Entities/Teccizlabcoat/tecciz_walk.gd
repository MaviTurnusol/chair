extends State

var target_pos := Vector2(0, 0)

func Start():
	target_pos = stateOwner.target_walking_position
	stateOwner.target_walking_position = Vector2(0, 0)

func PhysicsProcess(delta):
	stateOwner.velocity.x = lerp(stateOwner.velocity.x, sign(target_pos.x - stateOwner.global_position.x)*100.0, 0.1)
	stateOwner.move_and_slide()
	#print("im lerping!!!!")
