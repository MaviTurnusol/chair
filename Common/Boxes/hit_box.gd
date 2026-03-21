extends Area2D

@export var tiedFrames : PackedInt32Array
@export var atk := 1
signal harmed(dmg)

func _ready():
	area_entered.connect(harm)

func harm(area):
	if area.has_method("damage"):
		area.damage(atk, self)
		harmed.emit(atk)
	if area.has_method("intel"):
		area.intel(self)
