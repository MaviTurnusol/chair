extends Node
var RoomDict : Dictionary[String,Room]

signal switchscene(String)
signal setplayerposition(Vector2)
signal screamtodoors(String)

func _ready() -> void:
	var Rooms = dir_contents("res://RoomsAndLevels/")
	for r : Room in Rooms:
		if(r.SceneFilePath):
			r.Scene = load(r.SceneFilePath)
		elif(r.ScenePackedScene):
			r.Scene = r.ScenePackedScene
		else:
			assert(false,"ROOM RESOURCE ERROR at ROOM: " + r.Name)
		RoomDict[r.Name] = r

#CODE SNIPPET FROM ONLINE TO GET CONTENTS OF DIRECTORY
func dir_contents(path):
	var res_loads = []

	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.get_extension() == "tres":
					var full_path = path.path_join(file_name)
					res_loads.append(load(full_path))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

	return res_loads

func SwitchScene(WhatScene : String):
	switchscene.emit(WhatScene)

func SetPlayerPosition(NewPosition :Vector2):
	setplayerposition.emit(NewPosition)

func SwitchSceneAndPosition(WhatScene : String,WhatID:String):
	SwitchScene(WhatScene)
	await get_tree().process_frame
	screamtodoors.emit(WhatID)


#region Transition Specifics
var ActiveTransitionData : TransitionData
@onready var fader_color_rect: ColorRect = $FaderLayer/FaderColorRect

func PassTransition(transitionData : TransitionData,WhatScene : String,WhatID:String):
	ActiveTransitionData = transitionData
	await get_tree().process_frame
	UnlimitedRulebook.player.machine.change_state_to("dooring")
	
	await get_tree().create_timer(transitionData.Delay).timeout
	fader_color_rect.color = transitionData.TransparentMaskColour
	
	var FadeTween : Tween = get_tree().create_tween()
	FadeTween.set_ease(transitionData.EntryTweenEase)
	FadeTween.set_trans(transitionData.EntryTweenTransition)
	FadeTween.tween_property(fader_color_rect,"color",transitionData.MaskColour,transitionData.EntryTime)
	
	if(transitionData.DoSetPosition):
		FadeTween.tween_callback(SwitchSceneAndPosition.bind(WhatScene,WhatID))
	else:
		FadeTween.tween_callback(SwitchScene.bind(WhatScene))
	FadeTween.tween_interval(transitionData.SustainTime)
	
	FadeTween.set_ease(transitionData.ExitTTweenEase)
	FadeTween.set_trans(transitionData.ExitTweenTransition)
	FadeTween.tween_property(fader_color_rect,"color",transitionData.TransparentMaskColour,transitionData.ExitTime)
	
	await FadeTween.finished
	
	ActiveTransitionData = null
