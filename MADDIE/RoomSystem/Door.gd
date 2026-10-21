@icon("uid://dh4y12fn6jv5x")
extends Node2D

@export var TargetSceneName : String
@export var DoorIdentifier : String 
@export var transitionData : TransitionData

@export_category("PositionAtNewScene")
@export var DoSetPositionAtNewScene : bool
## Naming Convention is, "name of scene 1"_"name of scene 2"+DoorNumber
@export var talking_point_offset: Vector2

@export var PlayerMaxRange : float = 100

func action():
	#print(UnlimitedRulebook.player.machine.get_state())
	
	if(transitionData==null):
		if(UnlimitedRulebook.player.machine.get_state() not in ["meleeAttack"]):
			GoThroughDoor()
			return
	else:
		if UnlimitedRulebook.player:
			if is_instance_valid(UnlimitedRulebook.player):
				UnlimitedRulebook.player.machine.change_state_to("cutscene")
				UnlimitedRulebook.got_on_the_talking_point.connect(players_on_the_point)

func players_on_the_point():
	if UnlimitedRulebook.player:
		if is_instance_valid(UnlimitedRulebook.player):
			var midpoint = (UnlimitedRulebook.player.global_position + global_position)/2 + Vector2(0, 0)
			UnlimitedRulebook.cam.current_target = midpoint
			UnlimitedRulebook.got_on_the_talking_point.disconnect(players_on_the_point)
			GoThroughDoor()



func GoThroughDoor():
	if(transitionData == null):
		if(DoSetPositionAtNewScene):
			SceneManager.SwitchSceneAndPosition(TargetSceneName,DoorIdentifier)
		else:
			SceneManager.SwitchScene(TargetSceneName)
	else:
		SceneManager.PassTransition(transitionData,TargetSceneName,DoorIdentifier)

func _ready() -> void:
	SceneManager.screamtodoors.connect(CheckIfImCurrentScene)
	$InteractionPrompter.talking_point = global_position + talking_point_offset
	
	if(transitionData):
		transitionData = transitionData.duplicate()
		transitionData.DoSetPosition = DoSetPositionAtNewScene

func CheckIfImCurrentScene(seekedid:String):
	if(DoorIdentifier == seekedid):
		if(owner.get_parent()==UnlimitedRulebook.currentScene):
			SceneManager.SetPlayerPosition(global_position)
