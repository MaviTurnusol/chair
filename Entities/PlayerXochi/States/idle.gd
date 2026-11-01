extends State

var can_anim = false

func Start():
	can_anim = false
	$Timer.start()
	
func PhysicsProcess(_delta):
	print(can_anim)
	if abs(stateOwner.velocity.x) < 80.0 && can_anim:
		stateOwner.anima.play(animName)
	stateOwner.move_and_slide()

func End():
	can_anim = false
	$Timer.stop()


func _on_timer_timeout() -> void:
	can_anim = true
