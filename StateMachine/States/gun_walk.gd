extends State

var weapon

func Start():
	weapon = stateOwner.weaponHolder.get_child(0)

func Process(delta):
	var dir = Input.get_axis("left", "right")
	if dir:
		stateOwner.velocity.x = lerp(stateOwner.velocity.x, dir*stateOwner.speed*0.75, 0.1)
		if dir > 0:
			stateOwner.anima.play("gunWalk")
		else:
			stateOwner.anima.play_backwards("gunWalk")
	else:
		stateOwner.velocity.x = lerp(stateOwner.velocity.x, 0.0, 0.1)
		machine.change_state_to("gunIdle")
		#stateOwner.anima.pause()
		
	if UnlimitedRulebook.player.weapon_equipped:
		if Input.is_action_just_pressed("attack"):
			UnlimitedRulebook.playerWeapon.Use()
	
	stateOwner.get_node("Marker2D").scale.x = sign(stateOwner.get_global_mouse_position().x - stateOwner.global_position.x)
	
	stateOwner.move_and_slide()
	
