extends Button

@export_file_path("*.ini") var KeybindFilePath : String
@onready var keyRebinderParent: KeyRebinderParent = $"../.."
func _ready() -> void:
	pressed.connect(SetOwn)

func SetOwn():
	keyRebinderParent.LoadKeybindSettings(KeybindFilePath)
