@tool
@icon("uid://c58sbq1oa6cvf")
extends Node2D

@onready var interaction_prompt: InteractionPrompt = $InteractionPrompter

@export var WhatItemAmI : InventoryItem
@onready var sprite : Sprite2D = $Sprite2D
var pickedup : bool = false
func _ready() -> void:
	if(pickedup):
		queue_free()
	if(WhatItemAmI):
		WhatItemAmI = WhatItemAmI.duplicate()
	else:
		if(!Engine.is_editor_hint()):
			print("NO ITEM GIVEN")
			queue_free()
		return
	if(WhatItemAmI.ground_tex):
		sprite.texture = WhatItemAmI.ground_tex
		sprite.scale = Vector2.ONE * WhatItemAmI.ground_scalemulti

func action():
	if(pickedup):
		return
	pickedup = true
	interaction_prompt.DestroyAndAnimate()
	UnlimitedRulebook.player.inventory_component.AddItemToInventory(WhatItemAmI)
	queue_free()
