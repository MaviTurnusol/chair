extends ColorRect

func _ready() -> void:
	UnlimitedRulebook.NanaDialogueEndedBossFightStart.connect(FightStarted)

func FightStarted():
	color = Color.RED
