extends Button
@onready var ClearConfirmationDialogue : ConfirmationDialog = $QuitConfirmationDialog
signal ClearConfirmDialogueChosen
var ClearCode : int = 0

@export var WhatQuitType : ButtonType

enum ButtonType{
	QuitToMenu,
	QuitGame,
}

func _ready() -> void:
	pressed.connect(QuitGamePressed) 
	ClearConfirmationDialogue.connect("confirmed",ClearConfirmationDialogueChoice.bind(1))
	ClearConfirmationDialogue.connect("canceled",ClearConfirmationDialogueChoice.bind(0))

func QuitGamePressed():
	#ADD SAVED PROGRESS WARNING
	ClearConfirmationDialogue.popup()
	await ClearConfirmDialogueChosen
	if(ClearCode == 1):
		if(WhatQuitType==ButtonType.QuitGame):
			get_tree().quit()
			pass
		if(WhatQuitType==ButtonType.QuitToMenu):
			get_tree().call_deferred("change_scene_to_file","res://RoomsAndLevels/LevelScenes/MainMenu.tscn")
			get_tree().unload_current_scene()
			pass
		print("SAVE CLEARED")

func ClearConfirmationDialogueChoice(Code : int):
	match Code:
		0:
			ClearCode = 0
		1:
			ClearCode = 1
	ClearConfirmDialogueChosen.emit()
