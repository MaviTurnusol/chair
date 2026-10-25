extends Node

const SettingsConfigFilePath : String = "user://settings.cfg"

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
