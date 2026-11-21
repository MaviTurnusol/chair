extends State

var MoveSpeed = 100
var psetref : RoomTilesAStar
var Target

var path : PackedVector2Array

func Start() -> void:
	psetref = stateOwner.PathFindingSet

var targetisdoor : bool = false
func Process(delta: float) -> void:
	#if(UnlimitedRulebook.player.machine.get_state()=="dooring"):
		#Target = UnlimitedRulebook.player#
	if(UnlimitedRulebook.currentScene.room.Name == stateOwner.CurrentScene):
		path = psetref.getAStarPath(psetref.Grounded_ASTAR,stateOwner.global_position,UnlimitedRulebook.player.global_position)
	else:
		if(FindDoorToPlayer()):
			path = psetref.getAStarPath(psetref.Grounded_ASTAR,stateOwner.global_position,FindDoorToPlayer().global_position)
		#print("MAKING MY WAY")
			targetisdoor = true
		#print(path)
	
	if(stateOwner.global_position.distance_to(path.get(0))<32):
		if(path.size()>1):
			Target = path.get(1)
		else:
			Target = path.get(0)
	else:
		Target = path.get(0)
	
	if(targetisdoor):
		if(stateOwner.global_position.distance_to(Target)<8):
			GoThroughDoor()
			targetisdoor = false
	else:
			if(CheckDesireToGoThroughDoor()):
				if(UnlimitedRulebook.player.machine.get_state()!="dooring"):
					if(Target.distance_to(GetClosestDoor().global_position)==0):# && UnlimitedRulebook.player.global_position!=Target):
						#if(stateOwner.global_position.distance_to(Target)<48):
						GoThroughDoor()
						#stateOwner.global_position.y += 8
						Target = UnlimitedRulebook.player.global_position
						print("YES")
		
		
	#print(path)
	if(Target):
		stateOwner.velocity = stateOwner.global_position.direction_to(Target) * MoveSpeed
	stateOwner.dir = sign(stateOwner.velocity.x)
	stateOwner.move_and_slide()

func GoThroughDoor():
	GetClosestDoor().EntitySwitchScene(stateOwner)
	var rt = get_tree().get_nodes_in_group("RoomTiles")
	for i in rt:
		if(i.owner.get_parent().room.Name == stateOwner.CurrentScene):
			psetref = i
			#print("FOUND")
			break

func GetClosestDoor():
	var alldoors = GetAllDoorsInScene(owner.owner.get_parent().room.Name)
	var closestdoor : Door
	for d in alldoors:
		if(closestdoor == null):
			closestdoor = d
		if(stateOwner.global_position.distance_to(d.global_position)<stateOwner.global_position.distance_to(closestdoor.global_position)):
			closestdoor = d
	return closestdoor

func CheckDesireToGoThroughDoor():
	if(UnlimitedRulebook.currentScene.room.Name != stateOwner.CurrentScene):
		#print("I DESIRE TO CHANGE SCENE")
		return true
	if(GetClosestDoor().SameSceneDoors != Door.DoorPair.TargetScene):
		#print("Thsea are some nice doors")
		return true

func GetAllDoorsInScene(whatSceneName : String):
	var alldoors = get_tree().get_nodes_in_group("Obj_Door")
	var alldoorsinscene : Array[Door]
	for i in alldoors:
		if(i.owner.get_parent().room.Name==whatSceneName):
			alldoorsinscene.append(i)
	return alldoorsinscene

func FindDoorToPlayer():
	var alldoors : Array[Door]= GetAllDoorsInScene(owner.owner.get_parent().room.Name) #own scene
	#print(alldoors)
	#GetAllDoorsInScene(UnlimitedRulebook.currentScene.room.Name)
	for d in alldoors:
		if(d.TargetSceneName == UnlimitedRulebook.currentScene.room.Name):
			#print(d)
			return d
	return null
