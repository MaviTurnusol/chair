extends State

var attacker : Node2D
var duration : float = 1
func Start():
	duration = stateOwner.StaggerDuration
	if(stateOwner.dir != stateOwner.attackerDir):
		stateOwner.anima.play("hurtfront")
	else:
			stateOwner.anima.play("hurtback")
	stateOwner.set_collisions(false)
	get_tree().create_timer(duration).timeout.connect(Finish)

func Finish():
	stateOwner.machine.change_state_to("idle")

func PhysicsProcess(_delta):
	stateOwner.move_and_slide()

func End():
	stateOwner.set_collisions(true)
