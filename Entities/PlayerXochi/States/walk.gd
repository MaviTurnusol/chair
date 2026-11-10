extends State

func PhysicsProcess(_delta):
	
	if UnlimitedRulebook.lockedEnemyPosition != Vector2(0, 0):
		stateOwner.get_node("Marker2D").scale.x = sign(UnlimitedRulebook.lockedEnemyPosition.x - stateOwner.global_position.x)

	#stateOwner.get_node("Marker2D").scale.x = sign(stateOwner.get_global_mouse_position().x - stateOwner.global_position.x)
	stateOwner.velocity.x = lerp(stateOwner.velocity.x, stateOwner.dir*stateOwner.speed, 0.1)
	#if abs(stateOwner.velocity.x) <= stateOwner.speed * 1.35:
	
	if UnlimitedRulebook.lockedEnemyPosition != Vector2(0, 0):
		if int(stateOwner.get_node("Marker2D").scale.x) != int(sign(stateOwner.velocity.x)):
			stateOwner.anima.play("walkBackwards")
		#print("WWAWA")
		else:
			stateOwner.anima.play("walk")
	else:
		stateOwner.anima.play("walk")
		#print("direction: " + str(int(stateOwner.get_node("Marker2D").scale.x)))
		#print("velocity: " + str(int(sign(stateOwner.velocity.x))))
	
	stateOwner.move_and_slide()
