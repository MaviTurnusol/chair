extends Node

var LoadedSaveFile : SaveFile
const SettingsConfigFilePath : String = "user://settings.cfg"
signal GameSaved

func GetConfigFile(FilePath : String)->ConfigFile:
	var config = ConfigFile.new()
	var err = config.load(FilePath)
	if err != OK:
		return CreateConfigFile(FilePath)
	return config

func CreateConfigFile(FilePath : String):
	var config = ConfigFile.new()
	config.save(FilePath)
	return config

func LoadSaveFile(savefilepath : String): 
	print("I LOADED")
	LoadedSaveFile = ResourceLoader.load(savefilepath)

func CreateSaveFile(savefilepath : String):
	print("YABBA")
	LoadedSaveFile = SaveFile.new()
	LoadedSaveFile.SaveFilePath = savefilepath
	ResourceSaver.save(LoadedSaveFile,LoadedSaveFile.SaveFilePath)

func ClearSaveFile(savefilepath : String):
	CreateSaveFile(savefilepath)

func SaveCurrentGame():
	if(LoadedSaveFile):
		GameSaved.emit()
		LoadedSaveFile.Save()
		ResourceSaver.save(LoadedSaveFile,LoadedSaveFile.SaveFilePath)

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("SAVEGAMEDEBUG")):
		if(OS.is_debug_build()):
			print("DEBUG BUILD SAVE COMMAND")
			SaveCurrentGame()

func SetValueFromSave(targetVar : String,key : String,callingnode : Object)->bool:
	if(LoadedSaveFile):
		if(LoadedSaveFile.SavedData.has(key)):
			callingnode.set(targetVar,LoadedSaveFile.SavedData[key])
			return true
	return false
