extends Node

@export var Track : AudioStream

@export var OnReady : bool = false

func _ready() -> void:
	if(OnReady):
		AudioSystem.LoadTrackIntoDeck(Track,AudioSystem.Deck.DeckA)
		AudioSystem.PlayDeck(AudioSystem.Deck.DeckA)
	

func OnLoad():
	AudioSystem.LoadTrackIntoDeck(Track,AudioSystem.GetInactiveDeck())
	AudioSystem.CrossfadeDeck(1)
	AudioSystem.PlayDeck(AudioSystem.CurrentDeck)
	
