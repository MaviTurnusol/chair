extends Node2D
@onready var inventory_displayer: InventoryHud = $InventoryDisplayer
@export var PlayerMaxRange : float = 100
func action():
	inventory_displayer.visible = !inventory_displayer.visible

func _process(delta: float) -> void:
	if(UnlimitedRulebook.player.global_position.distance_to(global_position)>PlayerMaxRange):
		inventory_displayer.visible = false
