extends Node

var CurrentDeck : Deck = Deck.DeckA
enum Deck{
	DeckA,
	DeckB,
}

var DeckAPlayer : AudioStreamPlayer
var DeckBPlayer : AudioStreamPlayer

#DB so 0 is normal, -6 is 50% quieter etc
var DeckAVolume : float:
	set(value):
		DeckAVolume = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MusicDeckA"),value)
var DeckBVolume : float:
	set(value):
		DeckBVolume = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("MusicDeckB"),value)
var FaderTween : Tween

func CrossfadeDeck(timeToFade : float = 1):
	match CurrentDeck:
		Deck.DeckA:
			CurrentDeck = Deck.DeckB
			if(FaderTween):
				FaderTween.kill()
			FaderTween = get_tree().create_tween()
			FaderTween.set_parallel()
			FaderTween.tween_property(self,"DeckBVolume",0,timeToFade)
			FaderTween.tween_property(self,"DeckAVolume",-48,timeToFade)
		Deck.DeckB:
			CurrentDeck = Deck.DeckA
			if(FaderTween):
				FaderTween.kill()
			FaderTween = get_tree().create_tween()
			FaderTween.set_parallel()
			FaderTween.tween_property(self,"DeckAVolume",0,timeToFade)
			FaderTween.tween_property(self,"DeckBVolume",-48,timeToFade)

func LoadTrackIntoDeck(WhichTrack : AudioStream,WhichDeck : Deck):
	match WhichDeck:
		Deck.DeckA:
			DeckAPlayer.stream = WhichTrack
		Deck.DeckB:
			DeckBPlayer.stream = WhichTrack

func GetInactiveDeck():
	match CurrentDeck:
		Deck.DeckA:
			return Deck.DeckB
		Deck.DeckB:
			return Deck.DeckA

func PlayDeck(WhichDeck : Deck,FromPosition : float = 0):
	match WhichDeck:
		Deck.DeckA:
			DeckAPlayer.play(FromPosition)
		Deck.DeckB:
			DeckBPlayer.play(FromPosition)

var TempTrack1 : AudioStream = preload("uid://ul4lirqhf58o")
var TempTrack2 : AudioStream = preload("uid://bexsf6lorsp50")

func _ready() -> void:
	DeckAPlayer = AudioStreamPlayer.new()
	DeckAPlayer.bus = "MusicDeckA"
	DeckBPlayer = AudioStreamPlayer.new()
	DeckBPlayer.bus = "MusicDeckB"
	DeckAVolume = 0
	DeckBVolume = -48
	add_child(DeckAPlayer)
	add_child(DeckBPlayer)

var MusicFXTracer : Dictionary[int,AudioEffect]
var PauseAudioTween : Tween
func AddPauseAudioFX():
	var neweff : AudioEffectBandPassFilter = AudioEffectBandPassFilter.new()
	var neweff2 : AudioEffectDistortion = AudioEffectDistortion.new()
	neweff2.mode = AudioEffectDistortion.MODE_LOFI
	var neweff3 : AudioEffectPitchShift = AudioEffectPitchShift.new()
	
	var musmasteridx = AudioServer.get_bus_index("MusicMaster")
	
	AudioServer.add_bus_effect(musmasteridx,neweff)
	MusicFXTracer[AudioServer.get_bus_effect_count(musmasteridx)] = neweff
	
	AudioServer.add_bus_effect(musmasteridx,neweff2)
	MusicFXTracer[AudioServer.get_bus_effect_count(musmasteridx)] = neweff2
	
	AudioServer.add_bus_effect(musmasteridx,neweff3)
	MusicFXTracer[AudioServer.get_bus_effect_count(musmasteridx)] = neweff3
	
	if(PauseAudioTween):
		PauseAudioTween.kill()
	PauseAudioTween = get_tree().create_tween()
	PauseAudioTween.set_parallel()
	neweff.resonance = 0
	neweff.cutoff_hz = 500
	
	PauseAudioTween.tween_property(neweff,"resonance",1,1)
	PauseAudioTween.tween_property(neweff3,"pitch_scale",0.5,1)
	#MusicFXTracer[3].pitch_scale = 0.5

func TweenOutPauseAudioFX():
	if(!MusicFXTracer.has(1)):
		return
	var bandfilt = MusicFXTracer[1]
	
	if(PauseAudioTween):
		PauseAudioTween.kill()
	PauseAudioTween = get_tree().create_tween()
	PauseAudioTween.set_parallel()
	PauseAudioTween.tween_property(bandfilt,"resonance",0,1)
	PauseAudioTween.finished.connect(ClearMusicAudioFX)
	if(!MusicFXTracer.has(3)):
		return
	var pitchfilt = MusicFXTracer[3]
	PauseAudioTween.tween_property(pitchfilt,"pitch_scale",1,1)
	#TweenOutBandPass.finished.connect(ClearMusicAudioFX)

func ClearMusicAudioFX():
	var musmasteridx = AudioServer.get_bus_index("MusicMaster")
	for i in range(0,AudioServer.get_bus_effect_count(musmasteridx)):
		AudioServer.remove_bus_effect(musmasteridx,0)
	pass
