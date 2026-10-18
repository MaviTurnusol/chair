@icon("uid://dh4y12fn6jv5x")
extends Node2D

@export var TargetSceneName : String
@export var DoorIdentifier : String 

@export_category("PositionAtNewScene")
@export var DoSetPositionAtNewScene : bool
## Naming Convention is, "name of scene 1"_"name of scene 2"+DoorNumber


@export var PlayerMaxRange : float = 100
func action():
	print(UnlimitedRulebook.player.machine.get_state())
	if(UnlimitedRulebook.player.machine.get_state() not in ["meleeAttack"]):
		GoThroughDoor()

func GoThroughDoor():
	if(DoSetPositionAtNewScene):
		SceneManager.SwitchSceneAndPosition(TargetSceneName,DoorIdentifier)
	else:
		SceneManager.SwitchScene(TargetSceneName)

func _ready() -> void:
	SceneManager.screamtodoors.connect(CheckIfImCurrentScene)

func CheckIfImCurrentScene(seekedid:String):
	if(DoorIdentifier == seekedid):
		if(owner.get_parent()==UnlimitedRulebook.currentScene):
			SceneManager.SetPlayerPosition(global_position)
