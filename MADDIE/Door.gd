extends Node2D

@export var TargetSceneName : String


@export var PlayerMaxRange : float = 100
func action():
	GoThroughDoor()

func GoThroughDoor():
	SceneManager.SwitchScene(TargetSceneName)
