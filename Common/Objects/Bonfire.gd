@icon("uid://jyqcnqo0o01u")
extends Node2D

@export var PlayerMaxRange : float = 100
@export var talking_point_offset: Vector2
@export var SavedParts : CPUParticles2D
func action():
	if UnlimitedRulebook.player:
		if is_instance_valid(UnlimitedRulebook.player):
			UnlimitedRulebook.player.machine.change_state_to("cutscene")
			UnlimitedRulebook.got_on_the_talking_point.connect(players_on_the_point)

func players_on_the_point():
	if UnlimitedRulebook.player:
		if is_instance_valid(UnlimitedRulebook.player):
			#var midpoint = (UnlimitedRulebook.player.global_position + global_position)/2 + Vector2(0, 0)
			#UnlimitedRulebook.cam.current_target = midpoint
			UnlimitedRulebook.got_on_the_talking_point.disconnect(players_on_the_point)
			
			SaveManager.SaveCurrentGame()
			print("GAME SAVED")
			if(SavedParts):
				SavedParts.emitting = true
			await get_tree().process_frame
			UnlimitedRulebook.player.machine.change_state_to("idle")

func _ready() -> void:
	$InteractionPrompter.talking_point = global_position + talking_point_offset
