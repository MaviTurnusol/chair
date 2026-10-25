extends Node

@onready var settings_canvas_layer: CanvasLayer = $SettingsCanvasLayer

var IsSettingsActive : bool 

func _ready() -> void:
	HideSettings()

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("Settings")):
		if(IsSettingsActive):
			HideSettings()
		else:
			ShowSettings()

func ShowSettings():
	settings_canvas_layer.visible = true
	IsSettingsActive = true

func HideSettings():
	settings_canvas_layer.visible = false
	IsSettingsActive = false
