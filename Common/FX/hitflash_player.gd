extends Node
@export var TargetNodes : Array[Node2D]

var flashtime : float = 0:
	set(value):
		flashtime = value
		UpdateFlash()

func Flash():
	var NewTween : Tween = get_tree().create_tween()
	NewTween.tween_property(self,"flashtime",1,0.1)
	NewTween.tween_property(self,"flashtime",0,0.1)

func UpdateFlash():
	for node in TargetNodes:
		node.material.set_shader_parameter("FlashAmount",flashtime)
