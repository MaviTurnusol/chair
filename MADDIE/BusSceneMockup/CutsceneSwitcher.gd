extends Node

@export var TargetSceneName : String
@export var DoorIdentifier : String 
@export var transitionData : TransitionData
@export var DoSetPositionAtNewScene : bool = false

func _ready() -> void:
	if(transitionData):
		transitionData = transitionData.duplicate()
		transitionData.DoSetPosition = DoSetPositionAtNewScene
	await get_tree().create_timer(5).timeout
	Switch()

func Switch():
	if(transitionData == null):
		if(DoSetPositionAtNewScene):
			SceneManager.SwitchSceneAndPosition(TargetSceneName,DoorIdentifier)
		else:
			SceneManager.SwitchScene(TargetSceneName)
	else:
		SceneManager.PassTransition(transitionData,TargetSceneName,DoorIdentifier)
