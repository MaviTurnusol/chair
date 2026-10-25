@tool
extends Control
class_name ControlRebinder
## The text to show on screen
@export var DisplayActionName : String:
	set(value):
		DisplayActionName = value
		if(Engine.is_editor_hint()):
			action_name_label.text = DisplayActionName
## The name of the action being rebound
@export var RebindActionName : String:
	set(value):
		RebindActionName = value
		if(Engine.is_editor_hint()):
			SetLabelToAction()


@onready var KeyRebindParent : KeyRebinderParent =  $"../../.."
@onready var start_rebind_button: Button = $StartRebind
@onready var action_name_label: RichTextLabel = $ActionName

func _ready() -> void:
	SetLabelToAction()
	action_name_label.text = DisplayActionName
	if(Engine.is_editor_hint()):
		return
	start_rebind_button.pressed.connect(StartRebind)
	KeyRebindParent.KeyReboundSignal.connect(SetLabelToAction)

func StartRebind():
	KeyRebindParent.CurrentReboundActionName = RebindActionName
	KeyRebindParent.IsRebinding = true
	KeyRebindParent.keytext.text = KeyRebindParent.rebindstring + ": " + DisplayActionName


func SetLabelToAction():
	if(Engine.is_editor_hint()):
		var _t : String = GetActionKeyFromDefs(RebindActionName)
		print(_t)
		start_rebind_button.text = _t
	else:
		var inputmap = InputMap
		var input_events : Array[InputEvent] = inputmap.action_get_events(RebindActionName)
		var keyname : String
		for event in input_events:
			if(event is InputEventKey):
				keyname = OS.get_keycode_string(event.physical_keycode)
				start_rebind_button.text = keyname
			if(event is InputEventMouseButton):
				keyname = "Mouse" + str(event.button_index)
				match event.button_index:
					1:
						keyname = "LMB"
					2: 
						keyname = "RMB"
					3:
						keyname = "MMB"
				start_rebind_button.text = keyname


func GetActionKeyFromDefs(WhatAction : String)-> String:
	if(ProjectSettings.get_setting("input/"+WhatAction)):
		var keyDICT : Dictionary
		keyDICT = ProjectSettings.get_setting("input/"+WhatAction)
		var keyname
		if(keyDICT["events"][0] is InputEventKey):
			keyname = OS.get_keycode_string(keyDICT["events"][0].physical_keycode)
		if(keyDICT["events"][0] is InputEventMouseButton):
			keyname = "Mouse" + str((keyDICT["events"][0]).button_index)
			match (keyDICT["events"][0]).button_index:
				1:
					keyname = "LMB"
				2: 
					keyname = "RMB"
				3:
					keyname = "MMB"
			#print(keyname)
		return keyname
	return "No Input Action"
