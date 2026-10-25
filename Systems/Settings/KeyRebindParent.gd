extends Control
class_name KeyRebinderParent

@onready var keytext: Label = $VBoxContainer/KeyText
var promptstring : String

var IsRebinding : bool = false
@export var rebindstring : String
var CurrentReboundActionName : String = ""
signal KeyReboundSignal

@onready var ControlRebindParent: GridContainer = $VBoxContainer/GridContainer
var ControlRebinders : Array[ControlRebinder]
func _ready() -> void:
	promptstring = keytext.text
	for cr in ControlRebindParent.get_children():
		ControlRebinders.append(cr)
	LoadKeybindSettings()

func _input(event: InputEvent) -> void:
	if(!IsRebinding):
		return
	if(event.is_released()):
		return
	SetActionToNewEvent(CurrentReboundActionName,event)
	IsRebinding = false
	keytext.text = promptstring
	KeyReboundSignal.emit()
	SaveKeybindSettings()

func SetActionToNewEvent(ActionName : String,event : InputEvent):
	InputMap.erase_action(ActionName)
	InputMap.add_action(ActionName)
	InputMap.action_add_event(ActionName,event)

func SaveKeybindSettings():
	# Create new ConfigFile object.
	var config = SaveManager.GetConfigFile(SaveManager.SettingsConfigFilePath)
	# Store some values.
	for i in ControlRebinders:
		var tKC : String
		if(InputMap.action_get_events(i.RebindActionName)[0] is InputEventKey):
			tKC = InputMap.action_get_events(i.RebindActionName)[0].as_text()
			tKC = tKC.split("-",false)[0]
			tKC = tKC.trim_suffix(" ")
		if(InputMap.action_get_events(i.RebindActionName)[0] is InputEventMouseButton):
			var butindex = InputMap.action_get_events(i.RebindActionName)[0].button_index
			tKC = "m"+str(butindex)
		config.set_value("Keybind", i.RebindActionName, tKC)
	
	# Save it to a file (overwrite if already exists).
	config.save(SaveManager.SettingsConfigFilePath)

func LoadKeybindSettings(PathOverride : String = SaveManager.SettingsConfigFilePath):
	var config = SaveManager.GetConfigFile(PathOverride)
	if(config.has_section("Keybind")):
		for i in ControlRebinders:
			if(config.get_value("Keybind",i.RebindActionName)!=null):
				var KeyString : String = config.get_value("Keybind",i.RebindActionName)
				if(KeyString[0]=="m"):
					var NewMB : InputEventMouseButton = InputEventMouseButton.new()
					NewMB.button_index = int(KeyString.lstrip("m")) as MouseButton
					SetActionToNewEvent(i.RebindActionName,NewMB)
				else:
					var NewMKB : InputEventKey = InputEventKey.new()
					NewMKB.physical_keycode = OS.find_keycode_from_string(KeyString)
					print(NewMKB)
					SetActionToNewEvent(i.RebindActionName,NewMKB)
	KeyReboundSignal.emit()
