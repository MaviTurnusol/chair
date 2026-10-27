extends CanvasLayer

@onready var ResumeButton : Button = $PauseMenuControl/VBoxContainer/ResumeButton
@onready var SettingsButton : Button = $PauseMenuControl/VBoxContainer/SettingsButton
@onready var SaveLoadButton : Button = $PauseMenuControl/VBoxContainer/SaveLoadButton
@onready var QuitTitleButton : Button = $PauseMenuControl/VBoxContainer/QuitTitleButton
@onready var QuitAppButton : Button = $PauseMenuControl/VBoxContainer/QuitAppButton

@onready var QuitConfirmationDialogue : ConfirmationDialog = $ConfirmationDialog
signal QuitConfirmDialogueChosen
var QuitCode : int = 0

func _ready() -> void:
	ResumeButton.connect("pressed",Resume)
	SettingsButton.connect("pressed",ShowSettings)
	SaveLoadButton.connect("pressed",ShowSaveLoad)
	QuitTitleButton.connect("pressed",QuitTitle)
	QuitAppButton.connect("pressed",QuitApp)
	QuitConfirmationDialogue.connect("confirmed",QuitConfirmationDialogueChoice.bind(1))
	QuitConfirmationDialogue.connect("canceled",QuitConfirmationDialogueChoice.bind(0))

func ShowSettings():
	
	pass

func ShowSaveLoad():
	pass

func Resume():
	$PauseMenuControl.visible = false
	get_tree().paused = $PauseMenuControl.visible

func QuitTitle():
	#ADD SAVED PROGRESS WARNING
	QuitConfirmationDialogue.popup()
	await QuitConfirmDialogueChosen
	if(QuitCode == 1):
		Resume()
		get_tree().change_scene_to_file("res://Scenes/Levels/MainMenu.tscn")
	else:
		print("QuitCancelled")

func QuitApp():
	QuitConfirmationDialogue.popup()
	await QuitConfirmDialogueChosen
	if(QuitCode == 1):
		get_tree().quit()
	else:
		print("QuitCancelled")

func QuitConfirmationDialogueChoice(Code : int):
	match Code:
		0:
			QuitCode = 0
		1:
			QuitCode = 1
	QuitConfirmDialogueChosen.emit()

func _input(event: InputEvent) -> void:
	#MAKE TSCN GLOBAL + ADD BLACKLIST OF SCENES FOR PAUSE MENu
	if(!event.is_action_pressed("Pause")):
		return
	
	$PauseMenuControl.visible = !$PauseMenuControl.visible
	
	get_tree().paused = $PauseMenuControl.visible
