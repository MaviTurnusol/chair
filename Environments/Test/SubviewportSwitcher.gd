extends SubViewportContainer

var LoadedScenes : Array[RoomParent]

@export var plyr : Player
@export var camer : Camera2D

@export var StartingLoadedRoom : String

func GetActiveScene():
	return LoadedScenes[0]

func _ready() -> void:
	LoadScene("Lab")
	LoadScene("Hook Lab")
	LoadScene("Nana Boss Fight")
	LoadScene("Bus Travel")

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
	await get_tree().process_frame
	SetActiveScene()
	
