extends Node
class_name SaveLoad

@export var ObjToSave : Node
## Property to save Name In Save File,
@export var PropertiesToSave : Dictionary[String,String]
@export var QueueSaveWhileUnloaded : bool = true
@export var LoadOnReady : bool = true
func _ready() -> void:
	SaveManager.GameSaved.connect(QueuePropertiesForSave)
	if(LoadOnReady):
		LoadProperties()

func LoadProperties():
	for i in PropertiesToSave.keys():
		SaveManager.SetValueFromSave(i,PropertiesToSave[i],ObjToSave)

func QueuePropertiesForSave():
	for i in PropertiesToSave.keys():
		SaveManager.LoadedSaveFile.QueueSavedProperty(PropertiesToSave[i],ObjToSave.get(i))

func _exit_tree() -> void:
	if(QueueSaveWhileUnloaded):
		QueuePropertiesForSave()
