extends Control

@export var WhatItemAmI : InventoryItem
@onready var sprite : Sprite2D = $Sprite2D

func _ready() -> void:
	if(WhatItemAmI):
		global_position = get_global_mouse_position()
		#WhatItemAmI = WhatItemAmI.duplicate()
	else:
		print("NO ITEM GIVEN")
		queue_free()
		return
	if(WhatItemAmI.inventory_tex):
		sprite.texture = WhatItemAmI.inventory_tex
		sprite.scale = Vector2.ONE * WhatItemAmI.inv_scalemulti

var targetpos : Vector2
var targetrotation : float
var isPosSet : bool = false
func SetTargetPos(where : Vector2):
	targetpos = where
	isPosSet = true

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	if(isPosSet):
		sprite.global_position = sprite.global_position.move_toward(targetpos,100*delta) 
	else:
		sprite.position = sprite.position.move_toward(Vector2.ZERO,100*delta)
	
	targetrotation = deg_to_rad(WhatItemAmI.RotationState)
	#match WhatItemAmI.RotationState:
		#WhatItemAmI.Rotations.ZERO:
			#targetrotationdegrees = 0
		#WhatItemAmI.Rotations.NINETY:
			#targetrotationdegrees = 90
		#WhatItemAmI.Rotations.ONEEIGHTY:
			#targetrotationdegrees = 180
		#WhatItemAmI.Rotations.TWOSEVENTY:
			#targetrotationdegrees = 270
	rotation = move_toward(rotation,targetrotation,15*delta)
