extends State

var Target : Node2D
@export var MoveSpeed : float = 100

func Process(delta):
	if(Target):
		stateOwner.velocity = stateOwner.global_position.direction_to(Target.global_position) * MoveSpeed
	else:
		Target = UnlimitedRulebook.player
	stateOwner.move_and_slide()
