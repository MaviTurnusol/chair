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
	plyr.reparent(LoadedScenes[0])
	camer.reparent(LoadedScenes[0])
	move_child(LoadedScenes[0],-1)

func LoadScene(SceneName : String):
	var NewRoom : RoomParent = RoomParent.new()
	NewRoom.room = SceneManager.RoomDict[SceneName]
	add_child(NewRoom)
	RegetAllChildren()
	await get_tree().process_frame
	SetActiveScene()
	
