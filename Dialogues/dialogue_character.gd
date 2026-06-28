@tool

extends Control

@export var current_character := "Hatsune Miku"
@export var image : Texture
@export var on_screen := false : set = set_on_screen
@export_enum("left", "right") var facing: String = "right"

func set_on_screen(value):
	if value == on_screen:
		return
	if value == true:
		$AnimationPlayer.play("appear")
	if value == false:
		$AnimationPlayer.play_backwards("appear")
	on_screen = value

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	%CharacterTexture.texture = image
	if facing == "left":
		#%CharacterTexture.flip_h = true
		%CharacterTexture.set_anchors_preset(Control.PRESET_TOP_RIGHT)
		$Middler.scale.x = -1
	if facing == "right":
		#%CharacterTexture.flip_h = false
		%CharacterTexture.set_anchors_preset(Control.PRESET_TOP_LEFT)
		$Middler.scale.x = 1
	pass
