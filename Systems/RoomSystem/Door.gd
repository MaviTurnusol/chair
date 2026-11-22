@icon("uid://dh4y12fn6jv5x")
extends Node2D
class_name Door

@export var TargetSceneName : String
@export var DoorIdentifier : String 
@export var transitionData : TransitionData
@export var SameSceneDoors : DoorPair

enum DoorPair{
	TargetScene,
	BluePortal,
	OrangePortal
}

@export_category("PositionAtNewScene")
@export var DoSetPositionAtNewScene : bool
## Naming Convention is, "name of scene 1"_"name of scene 2"+DoorNumber
@export var talking_point_offset: Vector2

@export var PlayerMaxRange : float = 100

func action():
	#print(UnlimitedRulebook.player.machine.get_state())
	
	if(transitionData==null):
		if(UnlimitedRulebook.player.machine.get_state() not in ["meleeAttack","vineExit","vining"]):
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
			UnlimitedRulebook.cam.current_target = midpoint - Vector2(0,64)
			UnlimitedRulebook.got_on_the_talking_point.disconnect(players_on_the_point)
			GoThroughDoor()

func GoThroughDoor():
	if(transitionData == null):
		if(DoSetPositionAtNewScene):
			var appendSameDoors : String = ""
			if(SameSceneDoors == DoorPair.BluePortal):
				appendSameDoors = "Blue"
			elif(SameSceneDoors == DoorPair.OrangePortal):
				appendSameDoors = "Orange"
			SceneManager.SwitchSceneAndPosition(TargetSceneName,DoorIdentifier+appendSameDoors)
		else:
			SceneManager.SwitchScene(TargetSceneName)
	else:
		var appendSameDoors : String = ""
		if(SameSceneDoors == DoorPair.BluePortal):
			appendSameDoors = "Blue"
		elif(SameSceneDoors == DoorPair.OrangePortal):
			appendSameDoors = "Orange"
		SceneManager.PassTransition(transitionData,TargetSceneName,DoorIdentifier+appendSameDoors)

func EntitySwitchScene(who : Node2D):
	var appendSameDoors : String = ""
	if(SameSceneDoors == DoorPair.BluePortal):
		appendSameDoors = "Blue"
	elif(SameSceneDoors == DoorPair.OrangePortal):
		appendSameDoors = "Orange"
	SceneManager.EntitySwitchScene(who,TargetSceneName,DoorIdentifier+appendSameDoors)
	

func _ready() -> void:
	SceneManager.screamtodoors.connect(CheckIfImCurrentScene)
	SceneManager.entityscreamtodoors.connect(EntityCheckIfImCurrentScene)
	if(has_node("InteractionPrompter")):
		$InteractionPrompter.talking_point = global_position + talking_point_offset
	
	if(transitionData):
		transitionData = transitionData.duplicate()
		transitionData.DoSetPosition = DoSetPositionAtNewScene

func CheckIfImCurrentScene(seekedid:String):
	var appendSameDoors : String = ""
	if(SameSceneDoors == DoorPair.BluePortal):
		appendSameDoors = "Orange"
	elif(SameSceneDoors == DoorPair.OrangePortal):
		appendSameDoors = "Blue"
	if(DoorIdentifier+appendSameDoors == seekedid):
		if(owner.get_parent()==UnlimitedRulebook.currentScene):
			SceneManager.SetPlayerPosition(global_position)

func EntityCheckIfImCurrentScene(seekedid:String,entity : Node2D):
	var appendSameDoors : String = ""
	if(SameSceneDoors == DoorPair.BluePortal):
		appendSameDoors = "Orange"
	elif(SameSceneDoors == DoorPair.OrangePortal):
		appendSameDoors = "Blue"
	if(DoorIdentifier+appendSameDoors == seekedid):
		if(owner.get_parent().room.Name==entity.CurrentScene):
			entity.global_position = global_position
			#SceneManager.SetPlayerPosition(global_position)
