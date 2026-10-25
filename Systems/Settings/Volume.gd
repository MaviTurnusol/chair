extends Control

@onready var master_volume: HSlider = $VBoxContainer/MasterVolume
@onready var music_volume: HSlider = $VBoxContainer/MusicVolume
@onready var sfx_volume: HSlider = $VBoxContainer/SFXVolume
@onready var voiceover_volume: HSlider = $VBoxContainer/VoiceoverVolume

func _ready() -> void:
	LoadVolumeSettings()
	master_volume.value_changed.connect(SetMasterVolume)
	master_volume.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master"))
	music_volume.value_changed.connect(SetMusicVolume)
	music_volume.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("MusicMaster"))
	sfx_volume.value_changed.connect(SetSFXVolume)
	sfx_volume.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("SFXMaster"))
	voiceover_volume.value_changed.connect(SetVoiceOverVolume)
	voiceover_volume.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("DialogueMaster"))

func SaveVolumeSettings():
	# Create new ConfigFile object.
	var config = SaveManager.GetConfigFile(SaveManager.SettingsConfigFilePath)

	# Store some values.
	config.set_value("Volume", "master_volume",  AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master")))
	config.set_value("Volume", "music_volume", AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("MusicMaster")))
	config.set_value("Volume", "sfx_volume", AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("SFXMaster")))
	config.set_value("Volume", "voiceover_volume", AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("DialogueMaster")))

	# Save it to a file (overwrite if already exists).
	config.save(SaveManager.SettingsConfigFilePath)

func LoadVolumeSettings():
	var config = SaveManager.GetConfigFile(SaveManager.SettingsConfigFilePath)
	if(config.has_section("Volume")):
		SetMasterVolume(config.get_value("Volume", "master_volume"))
		SetMusicVolume(config.get_value("Volume", "music_volume"))
		SetSFXVolume(config.get_value("Volume", "sfx_volume"))
		SetVoiceOverVolume(config.get_value("Volume", "voiceover_volume"))

func SetMasterVolume(value : float):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"),value)
	SaveVolumeSettings()
func SetMusicVolume(value : float):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("MusicMaster"),value)
	SaveVolumeSettings()
func SetSFXVolume(value : float):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFXMaster"),value)
	SaveVolumeSettings()
func SetVoiceOverVolume(value : float):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("DialogueMaster"),value)
	SaveVolumeSettings()
