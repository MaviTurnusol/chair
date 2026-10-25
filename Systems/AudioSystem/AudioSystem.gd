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
