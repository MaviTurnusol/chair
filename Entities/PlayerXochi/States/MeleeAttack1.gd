extends State

func Start():
	#stateOwner.flip()
	#var markerdir = stateOwner.marker_2d.scale.x
	if(Input.get_axis("left","right")):
		stateOwner.marker_2d.scale.x = Input.get_axis("left","right")
		stateOwner.dir = stateOwner.marker_2d.scale.x
	else:
		stateOwner.get_node("Marker2D").scale.x = stateOwner.dir
	#print(stateOwner.marker_2d.scale.x)
	
	stateOwner.velocity.x = 0
	ProcessAnimation(UnlimitedRulebook.playerWeapon.CurrentAttack.AttackAnimation)
	var pweapon = UnlimitedRulebook.playerWeapon
	var time : float
	#if(!pweapon.CurrentAttack.AttackShouldLastAnimationDurationOverride):
	time = (pweapon.CurrentAttack.WindUpTime+pweapon.CurrentAttack.RecoveryTime+pweapon.CurrentAttack.AttackTime)
	#else: #LOWKEY thsis whoel else part could be deleted maybe
		#var animTime : float = 0
		#var animaref : AnimatedSprite2D= UnlimitedRulebook.player.anima
		#animTime = animaref.sprite_frames.get_frame_count(UnlimitedRulebook.MeleeAnimationDict[pweapon.CurrentAttack.AttackAnimation])/animaref.sprite_frames.get_animation_speed(UnlimitedRulebook.MeleeAnimationDict[pweapon.CurrentAttack.AttackAnimation])
		#time = animTime
	await get_tree().create_timer(time).timeout
	machine.change_state_to("idle")

func PhysicsProcess(_delta):
	#stateOwner.velocity.x = 0
	stateOwner.move_and_slide()

func ProcessAnimation(mAnimation : UnlimitedRulebook.MeleeAnimation):
	var animator = stateOwner.anima
	animator.stop()
	animator.play(UnlimitedRulebook.MeleeAnimationDict[mAnimation])
	
func End():
	if UnlimitedRulebook.lockedEnemyPosition != Vector2(0, 0):
		stateOwner.get_node("Marker2D").scale.x = sign(UnlimitedRulebook.lockedEnemyPosition.x - stateOwner.global_position.x)
	else:
		var newdir = Input.get_axis("left","right")
		if(newdir):
			stateOwner.get_node("Marker2D").scale.x = newdir
		#else:
			#stateOwner.dir = 0
	
