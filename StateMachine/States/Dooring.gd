extends State

func Start():
	var transData : TransitionData = SceneManager.ActiveTransitionData
	if(!transData):
		return
	stateOwner.set_collisions(false)
	canOnlyTransitionTo = ["dooring"]
	
	var TimeToWait : float = 0
	TimeToWait += transData.Delay
	TimeToWait += transData.EntryTime
	TimeToWait += transData.SustainTime
	
	stateOwner.anima.play(transData.PlayerAnimationOnEnter)
	await get_tree().create_timer(TimeToWait).timeout
	
	TimeToWait = 0
	TimeToWait += transData.ExitTime
	stateOwner.anima.play(transData.PlayerAnimationOnExit)
	
	await get_tree().create_timer(TimeToWait).timeout
	
	canOnlyTransitionTo = []

func End():
	stateOwner.set_collisions(true)
	UnlimitedRulebook.cam.current_target = Vector2.ZERO
