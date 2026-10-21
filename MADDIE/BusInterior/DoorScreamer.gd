extends Node2D

@export var DoorIdentifier : String 
func _ready() -> void:
	SceneManager.screamtodoors.connect(CheckIfImCurrentScene)

func CheckIfImCurrentScene(seekedid:String):
	if(DoorIdentifier == seekedid):
		print("IAM SOUGHT")
		if(owner.get_parent()==UnlimitedRulebook.currentScene):
			SceneManager.SetPlayerPosition(global_position)
