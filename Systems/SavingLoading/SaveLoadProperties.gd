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
	for i : String in PropertiesToSave.keys():
		#var PropsSub : PackedStringArray = i.split("/")
		#if(PropsSub.size()==1):
		var success = SaveManager.SetValueFromSave(i,PropertiesToSave[i],ObjToSave)
		if(success):
			if(ObjToSave.has_method("OnLoad")):
				ObjToSave.OnLoad(i)
		#else:
			#var curref : Object
			#for pSP_Index in range(0,PropsSub.size()-1):
				#curref = curref.get(PropsSub[pSP_Index])
			#var success = SaveManager.SetValueFromSave(i,PropertiesToSave[i],curref)
			#if(success):
				#if(curref.has_method("OnLoad")):
					#curref.OnLoad(i)

func QueuePropertiesForSave():
	for i in PropertiesToSave.keys():
		if(SaveManager.LoadedSaveFile):
			SaveManager.LoadedSaveFile.QueueSavedProperty(PropertiesToSave[i],ObjToSave.get(i))

func _exit_tree() -> void:
	if(QueueSaveWhileUnloaded):
		QueuePropertiesForSave()
