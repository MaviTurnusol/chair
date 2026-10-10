extends State

func Start():
	stateOwner.velocity.x = 0
	ProcessAnimation(UnlimitedRulebook.playerWeapon.CurrentAttack.AttackAnimation)
	var pweapon = UnlimitedRulebook.playerWeapon
	var time = (pweapon.CurrentAttack.WindUpTime+pweapon.CurrentAttack.RecoveryTime+pweapon.CurrentAttack.AttackTime)
	await get_tree().create_timer(time).timeout
	machine.change_state_to("idle")

func PhysicsProcess(_delta):
	#stateOwner.velocity.x = 0
	stateOwner.move_and_slide()

func ProcessAnimation(mAnimation : UnlimitedRulebook.MeleeAnimation):
	var animator = stateOwner.anima
	animator.stop()
	match mAnimation:
		UnlimitedRulebook.MeleeAnimation.Null:
			pass
		UnlimitedRulebook.MeleeAnimation.Stab1:
			animator.play("stab1")
		UnlimitedRulebook.MeleeAnimation.Thrust1:
			animator.play("thrust1")
		UnlimitedRulebook.MeleeAnimation.idk:
			animator.play("fall")
		UnlimitedRulebook.MeleeAnimation.KnifeSlash1:
			animator.play("knifeslash1")
