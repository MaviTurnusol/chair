extends State

var combo = 1
var weapon

func Start():
	stateOwner.anima.stop()
	weapon = stateOwner.weaponHolder.get_child(0)
	animName = "groundAttack" + str(combo)
	weapon.anima.play(animName)
	weapon.anima.visible = true
	weapon.anima.animation_finished.connect(CustomEnd)
	pass

func PhysicsProcess(_delta):
	stateOwner.move_and_slide()
	stateOwner.velocity.x = lerp(stateOwner.velocity.x, 0.0, 0.1)

func CustomEnd():
	if weapon.anima.animation != animName:
		return
	weapon.anima.animation_finished.disconnect(CustomEnd)
	weapon.anima.play("blank")
	machine.change_state_to("idle")
