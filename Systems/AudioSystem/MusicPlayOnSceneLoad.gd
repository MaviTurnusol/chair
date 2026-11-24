extends Node

@export var Track : AudioTrack
@export var FadeTime : float = 3

@export var Layers : Array[int] = [-1]

@export var OnReady : bool = false

func _ready() -> void:
	if(OnReady):
		OnLoad()
	

func OnLoad():
	if(AudioSystem.GetActiveTrack()==Track):
		return
	
	AudioSystem.LoadTrackIntoDeck(Track,AudioSystem.GetInactiveDeck())
	AudioSystem.CrossfadeDeck(FadeTime)
	#AudioSystem.PlayDeck(AudioSystem.CurrentDeck)
	AudioSystem.GetActiveTrack().PlayTrack(0,Layers)
	print(AudioSystem.GetActiveTrack())
	#AudioSystem.DeckBTrack.PlayTrack(0,[0])
