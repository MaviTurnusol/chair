extends Node
var RoomDict : Dictionary[String,Room]

signal switchscene(String)
signal setplayerposition(Vector2)
signal screamtodoors(String)
signal unloadallbutcurrentscene(String)

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

func UnloadAllButCurrentScene():
	unloadallbutcurrentscene.emit()

#region Transition Specifics
var ActiveTransitionData : TransitionData
@onready var fader_color_rect: ColorRect = $FaderLayer/FaderColorRect
@onready var animation_colour_rect: ColorRect = $AnimationLayer/AnimationColourRect
@onready var posterize_colour_rect: ColorRect = $PosterizeLayer/PosterizeColourRect

func PassTransition(transitionData : TransitionData,WhatScene : String,WhatID:String):
	ActiveTransitionData = transitionData
	await get_tree().process_frame
	UnlimitedRulebook.player.machine.change_state_to("dooring")
	if(!transitionData.MaskAnimationName):
		FadeTransition(transitionData,WhatScene,WhatID)
	else:
		AnimationTransition(transitionData,WhatScene,WhatID)

func FadeTransition(transitionData : TransitionData,WhatScene : String,WhatID:String):
	await get_tree().create_timer(transitionData.Delay).timeout
	fader_color_rect.color = transitionData.TransparentMaskColour
	
	fader_color_rect.visible = true
	
	if(transitionData.DoPosterize):
		PosterizeTransition(transitionData)
	
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
	
	if(transitionData.DoFadeOut):
		FadeTween.tween_property(fader_color_rect,"color",transitionData.TransparentMaskColour,transitionData.ExitTime)
	else:
		FadeTween.tween_interval(transitionData.ExitTime)
	
	await FadeTween.finished
	fader_color_rect.visible = false
	ActiveTransitionData = null

func AnimationTransition(transitionData : TransitionData,WhatScene : String,WhatID:String):
	await get_tree().create_timer(transitionData.Delay).timeout
	animation_colour_rect.color = transitionData.TransparentMaskColour
	animation_colour_rect.visible = true
	animation_colour_rect.scale = Vector2.ONE
	
	if(transitionData.DoPosterize):
		PosterizeTransition(transitionData)
	
	animation_colour_rect.SetScale(transitionData.AnimationScale)
	
	var FadeTween : Tween = get_tree().create_tween()
	FadeTween.set_ease(transitionData.EntryTweenEase)
	FadeTween.set_trans(transitionData.EntryTweenTransition)
	
	FadeTween.tween_property(animation_colour_rect,"color",transitionData.MaskColour,transitionData.EntryTime)
	
	if(!transitionData.WaitUntilSustain):
		animation_colour_rect.PlayMaskAnim(transitionData.MaskAnimationName)
	else:
		var cal : Callable = Callable(animation_colour_rect,"PlayMaskAnim").bind(transitionData.MaskAnimationName)
		animation_colour_rect.PlayMaskAnim("null")
		FadeTween.tween_callback(cal)
	if(transitionData.DoSetPosition):
		FadeTween.tween_callback(SwitchSceneAndPosition.bind(WhatScene,WhatID))
	else:
		FadeTween.tween_callback(SwitchScene.bind(WhatScene))
	FadeTween.tween_interval(transitionData.SustainTime)
	if(transitionData.tweenMaskOut):
		FadeTween.tween_callback(ScaleMaskOut)
	FadeTween.set_ease(transitionData.ExitTTweenEase)
	FadeTween.set_trans(transitionData.ExitTweenTransition)
	if(transitionData.DoFadeOut):
		FadeTween.tween_property(animation_colour_rect,"color",transitionData.TransparentMaskColour,transitionData.ExitTime)
	else:
		FadeTween.tween_interval(transitionData.ExitTime)
	await FadeTween.finished
	animation_colour_rect.visible = false
	ActiveTransitionData = null

func ScaleMaskOut():
		var maskouttween : Tween = get_tree().create_tween()
		maskouttween.tween_property(animation_colour_rect,"scale",ActiveTransitionData.maskoutDestinationScale,ActiveTransitionData.ExitTime)

var poster : int = 8:
	set(value):
		posterize_colour_rect.material.set_shader_parameter("bits",value)
		poster = value
func PosterizeTransition(transitionData : TransitionData):
	await get_tree().create_timer(transitionData.Delay).timeout
	posterize_colour_rect.visible = true
	#posterize_colour_rect.material.set_shader_parameter("bits",2)
	var PosterizeTween : Tween = get_tree().create_tween()
	PosterizeTween.set_trans(Tween.TRANS_SINE)
	PosterizeTween.set_ease(Tween.EASE_OUT)
	PosterizeTween.tween_property(self,"poster",2,transitionData.EntryTime)
	
	PosterizeTween.tween_interval(transitionData.SustainTime)
	PosterizeTween.set_ease(Tween.EASE_IN)
	PosterizeTween.tween_property(self,"poster",8,transitionData.ExitTime)
	await PosterizeTween.finished
	posterize_colour_rect.visible = false
