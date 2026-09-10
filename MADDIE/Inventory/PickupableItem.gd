@tool
extends Node2D

@onready var interaction_prompt: InteractionPrompt = $InteractionPrompter

@export var WhatItemAmI : InventoryItem
@onready var sprite : Sprite2D = $Sprite2D

func _ready() -> void:
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
	interaction_prompt.DestroyAndAnimate()
	UnlimitedRulebook.player.inventory_component.AddItemToInventory(WhatItemAmI)
	queue_free()
