extends Node

func _ready() -> void:
	UnlimitedRulebook.NanaDialogueEndedBossFightStart.connect(FightStarted)

func FightStarted():
	pass
	#color = Color.RED
