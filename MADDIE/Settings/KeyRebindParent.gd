extends Control
class_name KeyRebinder

@onready var keytext: Label = $VBoxContainer/KeyText
var promptstring : String

var IsRebinding : bool = false
@export var rebindstring : String
var CurrentReboundActionName : String = ""
signal KeyReboundSignal
func _ready() -> void:
	promptstring = keytext.text

func _input(event: InputEvent) -> void:
	if(!IsRebinding):
		return
	if(event.is_released()):
		return
	InputMap.erase_action(CurrentReboundActionName)
	InputMap.add_action(CurrentReboundActionName)
	InputMap.action_add_event(CurrentReboundActionName,event)
	IsRebinding = false
	keytext.text = promptstring
	KeyReboundSignal.emit()
