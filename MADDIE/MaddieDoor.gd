extends Node2D
class_name Door
@export var DoorKey : int
@export var LayerDirection : int = 1
@export var OwnLayer : int = 0

@onready var area_2d: Area2D = $Area2D
@onready var entry_point: Marker2D = $EntryPoint
var Enterable : bool = false

func _ready() -> void:
	area_2d.body_entered.connect(BodyEntered)
	area_2d.body_exited.connect(BodyExited)

func BodyEntered(body : Node2D):
	if(body.is_in_group("player")):
		Enterable = true

func BodyExited(body : Node2D):
	if(body.is_in_group("player")):
		Enterable = false

func _input(event: InputEvent) -> void:
	if(!Enterable):
		return
	if(event.is_action_pressed("interact")):
		Enter()

func Enter():
	#ENTER DOOR
	pass
