extends Node

@export var Track : AudioStream
@export var FadeTime : float = 3
@export var OnReady : bool = false

func _ready() -> void:
	if(OnReady):
		OnLoad()
	

func OnLoad():
	AudioSystem.LoadTrackIntoDeck(Track,AudioSystem.GetInactiveDeck())
	AudioSystem.CrossfadeDeck(FadeTime)
	AudioSystem.PlayDeck(AudioSystem.CurrentDeck)
	
