extends Control

@onready var master_volume: HSlider = $VBoxContainer/MasterVolume
@onready var music_volume: HSlider = $VBoxContainer/MusicVolume
@onready var sfx_volume: HSlider = $VBoxContainer/SFXVolume
@onready var voiceover_volume: HSlider = $VBoxContainer/VoiceoverVolume

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_volume.value_changed.connect(SetMasterVolume)
	master_volume.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master"))
	music_volume.value_changed.connect(SetMusicVolume)
	music_volume.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("MusicMaster"))
	sfx_volume.value_changed.connect(SetSFXVolume)
	sfx_volume.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("SFXMaster"))
	voiceover_volume.value_changed.connect(SetVoiceOverVolume)
	voiceover_volume.value = AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("DialogueMaster"))

func SetMasterVolume(value : float):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"),value)
func SetMusicVolume(value : float):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("MusicMaster"),value)
func SetSFXVolume(value : float):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFXMaster"),value)
func SetVoiceOverVolume(value : float):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("DialogueMaster"),value)
