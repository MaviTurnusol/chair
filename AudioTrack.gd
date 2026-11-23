extends Resource
class_name AudioTrack

@export var Layers : Array[AudioStream]
var AudioPlayers : Array[AudioStreamPlayer]
var AudioFX : Array[AudioEffect]

@export var VolumeDB : float = 0:
	set(NewVolume):
		VolumeDB = NewVolume
		for AP in AudioPlayers:
			AP.volume_db = VolumeDB

var MyDeck : AudioSystem.Deck
var MyDeckIndex : int

func _init(_layers : Array[AudioStream]) -> void:
	for AS in _layers:
		var newAudioPlayer : AudioStreamPlayer = AudioStreamPlayer.new()
		AudioPlayers.append(newAudioPlayer)
		newAudioPlayer.stream = AS
		AudioSystem.add_child(newAudioPlayer)
		newAudioPlayer.volume_db = VolumeDB

func SetDeck(whichDeck : AudioSystem.Deck):
	MyDeck = whichDeck
	for AP in AudioPlayers:
		match MyDeck:
			AudioSystem.Deck.DeckA:
				MyDeckIndex = AudioSystem.DeckAIndex
			AudioSystem.Deck.DeckB:
				MyDeckIndex = AudioSystem.DeckBIndex
		AP.bus = AudioServer.get_bus_name(MyDeckIndex)

func PlayTrack(FromWhere : float=0,WhichLayers : Array[int]=[]):
	
	
	
	pass

func AddEffect(NewEffect : AudioEffect):
	AudioFX.append(NewEffect)
	pass

func Destroy():
	ClearAudioFX()
	for AP in AudioPlayers:
		AP.queue_free()

func ClearAudioFX():
	for fxidx in range(AudioServer.get_bus_effect_count(MyDeckIndex)):
		AudioServer.remove_bus_effect(MyDeckIndex,0)
