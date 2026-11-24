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

func Create() -> void:
	for AS in Layers:
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
	print(MyDeck)

func PlayTrack(FromWhere : float=0,WhichLayers : Array[int]=[-1]):
	if(WhichLayers == [-1]):
		for idx in range(0,AudioPlayers.size()-1):
			WhichLayers.append(idx)
	for layer in WhichLayers:
		AudioPlayers[layer].play(FromWhere)

func AddLayerToPlaying(_layer : int,DoFade:bool = true):
	AudioPlayers[_layer].play(InferPlaybackPosition())
	print("Track " + str(_layer) + " Added")
	if(DoFade):
		var ref = AudioPlayers[_layer]
		ref.volume_db = -48
		var FadeIn : Tween = AudioSystem.create_tween()
		FadeIn.tween_property(ref,"volume_db",0,1)

func RemoveLayerFromPlaying(_layer : int,DoFade:bool = true):
	print("Track " + str(_layer) + " Removed")
	if(DoFade):
		var ref = AudioPlayers[_layer]
		ref.volume_db = 0
		var FadeIn : Tween = AudioSystem.create_tween()
		FadeIn.tween_property(ref,"volume_db",-48,1)
		FadeIn.finished.connect(ref.stop)
	else:
		AudioPlayers[_layer].stop()

func InferPlaybackPosition() -> float:
	for AP in AudioPlayers:
		if(AP.playing):
			return AP.get_playback_position()
	return 0

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
