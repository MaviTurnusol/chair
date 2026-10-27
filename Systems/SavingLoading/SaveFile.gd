extends Resource
class_name SaveFile

@export var SaveFilePath : String
@export var SavedData : Dictionary[String,Variant] ={}
@export var QueueSavedData : Dictionary[String,Variant] ={}

func Save():
	SaveCurrentRoom()
	
	for key in QueueSavedData.keys():
		SavedData[key] = QueueSavedData[key]

func SaveCurrentRoom():
	SavedData["CurrentRoom"] = UnlimitedRulebook.currentScene.room.Name
	print(SavedData["CurrentRoom"])

func QueueSavedProperty(key : String, value : Variant):
	QueueSavedData[key] = value
