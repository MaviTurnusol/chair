extends SubViewportContainer

var SubviewportChildren : Array[SubViewport]

@export var plyr : Player
@export var camer : Camera2D

func _ready() -> void:
	RegetAllChildren()

func RegetAllChildren():
	SubviewportChildren.clear()
	for c in get_children():
		if(c is SubViewport):
			SubviewportChildren.append(c)

func  _input(event: InputEvent) -> void:
	return
	if(event.is_action_pressed("attack")):
		RegetAllChildren()
		SetActiveScene()

func SetActiveScene():
	plyr.reparent(SubviewportChildren[0])
	camer.reparent(SubviewportChildren[0])
	move_child(SubviewportChildren[0],-1)
