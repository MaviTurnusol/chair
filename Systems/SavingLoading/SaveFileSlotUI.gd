extends Control
class_name SaveSlotUI
@export var NextScene : Room
@onready var load_save: Button = $LoadSave
@onready var clear_save: Button = $ClearSave
@onready var save_slot_label: RichTextLabel = $SaveSlotLabel
const tprompt = "[shake]Save Slot "
@onready var ClearConfirmationDialogue : ConfirmationDialog = $QuitConfirmationDialog
signal ClearConfirmDialogueChosen
var ClearCode : int = 0
var Index : int

func _ready() -> void:
	clear_save.connect("pressed",ClearSavePressed)
	ClearConfirmationDialogue.connect("confirmed",ClearConfirmationDialogueChoice.bind(1))
	ClearConfirmationDialogue.connect("canceled",ClearConfirmationDialogueChoice.bind(0))
	load_save.pressed.connect(LoadSave)

func LoadSave():
	if(FileAccess.file_exists("user://save_game"+str(Index)+"_geo_.tres")):
		SaveManager.LoadSaveFile("user://save_game"+str(Index)+"_geo_.tres")
	else:
		SaveManager.CreateSaveFile("user://save_game"+str(Index)+"_geo_.tres")
		print("FUCK YOU")
	StartGame()

func StartGame():
	get_tree().change_scene_to_packed(NextScene.Scene)

func ClearSavePressed():
	#ADD SAVED PROGRESS WARNING
	ClearConfirmationDialogue.popup()
	await ClearConfirmDialogueChosen
	if(ClearCode == 1):
		ClearSave()
		print("SAVE CLEARED")

func ClearSave():
	SaveManager.ClearSaveFile("user://save_game"+str(Index)+"_geo_.tres")

func ClearConfirmationDialogueChoice(Code : int):
	match Code:
		0:
			ClearCode = 0
		1:
			ClearCode = 1
	ClearConfirmDialogueChosen.emit()
