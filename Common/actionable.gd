extends Area2D


@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var talking_point: Vector2

func action() -> void:
	#DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)
	#DialogueManager.show_dialogue_balloon_scene(load("res://Dialogues/SpeechBubbies/dialogue_balloon.tscn"), dialogue_resource, dialogue_start)
	
	if UnlimitedRulebook.player:
		if is_instance_valid(UnlimitedRulebook.player):
			UnlimitedRulebook.player.machine.change_state_to("cutscene")
			UnlimitedRulebook.got_on_the_talking_point.connect(players_on_the_point)

func players_on_the_point():
	DialogueManager.show_dialogue_balloon_scene(load("res://Dialogues/SpeechBubbies/dialogue_balloon.tscn"), dialogue_resource, dialogue_start)
	
	if UnlimitedRulebook.player:
		if is_instance_valid(UnlimitedRulebook.player):
			
			UnlimitedRulebook.player.machine.change_state_to("talk")
			
			var midpoint = (UnlimitedRulebook.player.global_position + global_position)/2 + Vector2(0, 0)
			UnlimitedRulebook.cam.current_target = midpoint
			UnlimitedRulebook.got_on_the_talking_point.disconnect(players_on_the_point)
