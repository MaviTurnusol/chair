@icon("uid://cbi1n2nhvnoi2")
extends Node2D
@export var InventoryDisplayer : InventoryHud
@export var PlayerMaxRange : float = 100

func action():
	InventoryDisplayer.visible = !InventoryDisplayer.visible

func _process(delta: float) -> void:
	if(UnlimitedRulebook.player):
		if(UnlimitedRulebook.player.global_position.distance_to(global_position)>PlayerMaxRange):
			InventoryDisplayer.visible = false
