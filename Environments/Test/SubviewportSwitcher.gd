@icon("uid://4uvvr76misin")
extends SubViewportContainer

var LoadedScenes : Array[RoomParent]

@export var plyr : Player
@export var camer : Camera2D

@export var StartingLoadedRoom : String

func GetActiveScene():
	return LoadedScenes[0]

func _ready() -> void:
	SceneManager.switchscene.connect(SwitchToScene)
	LoadScene(StartingLoadedRoom)
	await get_tree().process_frame
	SetActiveScene()
	#LoadScene("Hook Lab")
	#LoadScene("Nana Boss Fight")
	#LoadScene("Bus Travel")

func SwitchToScene(WhatScene :String):
	var isLoaded:bool=false
	var sceneref : RoomParent
	#check if its loaded
	for sce in LoadedScenes:
		if(sce.room.Name==WhatScene):
			isLoaded = true
			sceneref = sce
			break
	#if its not loaded then load it
	if(!isLoaded):
		LoadScene(WhatScene)
		isLoaded = true
		for sce in LoadedScenes:
			if(sce.room.Name==WhatScene):
				sceneref = sce
				break
	
	#Switch The Running Scene to awiag
	UnlimitedRulebook.currentScene = sceneref
	var ActiveSceneSceneName : String = sceneref.room.Name
	
	if(SceneManager.RoomDict[ActiveSceneSceneName].BringPlayer):
		plyr.reparent(sceneref)
		camer.reparent(sceneref)
		camer.enabled = true
		plyr.set_process(true)
		plyr.set_physics_process(true)
	else:
		plyr.set_process(false)
		plyr.set_physics_process(false)
		camer.disabled = false
	move_child(sceneref,-1)

func RegetAllChildren():
	LoadedScenes.clear()
	for c in get_children():
		if(c is RoomParent):
			LoadedScenes.append(c)
	

func  _input(event: InputEvent) -> void:
	if(event.is_action_pressed("switchscene")):
		RegetAllChildren()
		SetActiveScene()

func SetActiveScene():
	UnlimitedRulebook.currentScene = LoadedScenes[0]
	var ActiveSceneSceneName : String = LoadedScenes[0].room.Name
	
	if(SceneManager.RoomDict[ActiveSceneSceneName].BringPlayer):
		plyr.reparent(LoadedScenes[0])
		camer.reparent(LoadedScenes[0])
		camer.enabled = true
		plyr.set_process(true)
		plyr.set_physics_process(true)
	else:
		plyr.set_process(false)
		plyr.set_physics_process(false)
		camer.disabled = false
	move_child(LoadedScenes[0],-1)

func LoadScene(SceneName : String):
	var NewRoom : RoomParent = RoomParent.new()
	NewRoom.room = SceneManager.RoomDict[SceneName]
	add_child(NewRoom)
	RegetAllChildren()
