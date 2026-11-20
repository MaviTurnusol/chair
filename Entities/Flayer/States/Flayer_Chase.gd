extends State

var Target : Node2D
@export var MoveSpeed : float = 100

func Process(delta):
	if(UnlimitedRulebook.currentScene.room.Name == stateOwner.CurrentScene):
		Target = UnlimitedRulebook.player
	else:
		if(!Target is Door):
			Target = FindDoorToPlayer()
	
	if(Target):
		stateOwner.velocity = stateOwner.global_position.direction_to(Target.global_position) * MoveSpeed
		if(Target != UnlimitedRulebook.player):
			if(stateOwner.global_position.distance_to(Target.global_position)<5):
				EnterDoor()
	stateOwner.dir = sign(stateOwner.velocity.x)
	stateOwner.move_and_slide()

func EnterDoor():
	var tdoor : Door = Target
	tdoor.EntitySwitchScene(stateOwner)
	print("flayerrrr")
	Target = null
	pass

func FindDoorToPlayer():
	var alldoors : Array[Door]= GetAllDoorsInScene(owner.owner.get_parent().room.Name) #own scene
	#print(alldoors)
	#GetAllDoorsInScene(UnlimitedRulebook.currentScene.room.Name)
	for d in alldoors:
		if(d.TargetSceneName == UnlimitedRulebook.currentScene.room.Name):
			return d
	return null


func GetAllDoorsInScene(whatSceneName : String):
	var alldoors = get_tree().get_nodes_in_group("Obj_Door")
	var alldoorsinscene : Array[Door]
	for i in alldoors:
		if(i.owner.get_parent().room.Name==whatSceneName):
			alldoorsinscene.append(i)
	return alldoorsinscene
