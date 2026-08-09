extends State

func Start():
	var pweapon = UnlimitedRulebook.playerWeapon
	var time = (pweapon.WindUpTime+pweapon.RecoveryTime+pweapon.AttackTime)
	await get_tree().create_timer(time).timeout
	machine.change_state_to("idle")

func PhysicsProcess(_delta):
	stateOwner.velocity.x = 0
	stateOwner.move_and_slide()
	
