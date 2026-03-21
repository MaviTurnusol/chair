extends Node

@export var MAX_HEALTH : float
@export var health : float : set = set_health
@export var father : Node

signal healthChanged(oldVal, newVal)

func set_health(value):
	if value >= MAX_HEALTH:
		value = MAX_HEALTH
	if value <= 0:
		value = 0
		if father:
			if father.has_method("death"):
				father.death()
	if value != health:
		healthChanged.emit(health, value)
		health = value

func _ready():
	health = MAX_HEALTH

func damage(attack):
	health -= attack
	#print(health)
