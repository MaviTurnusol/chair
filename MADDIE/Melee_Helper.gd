extends Node
class_name MeleeHelper

@onready var player: Player = $"../.."

func _ready() -> void:
	get_child(0).Body = player

func Attack():
	player.machine.change_state_to("meleeAttack1")
	
func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("attack")):
		get_child(0).Use()
