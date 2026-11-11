extends CharacterBody2D

var target_walking_position := Vector2(522, 340)

@onready var machine = $StateMachine
@onready var anima = $Marker2D/anima

func ready():
	#machine.change_state_to("teccizWalk")
	#print(machine.get_state())
	pass

func _process(_delta: float) -> void:
	if machine.get_state() not in ["teccizWalk"]:
		machine.change_state_to("teccizWalk")
		print("me workey")
