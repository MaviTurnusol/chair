extends Node2D

@onready var START_BUTTON: Button = $CanvasLayer/Control/StartButton
@export var NextScene : Room
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	START_BUTTON.pressed.connect(StartGame)

func StartGame():
	get_tree().change_scene_to_packed(NextScene.Scene)
	
