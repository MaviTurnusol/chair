extends Control
class_name HandHeldItemSlot
var IsHovered : bool

@export var AssocInvHud : InventoryHud
signal HandItemChanged

var iteminslotref : InventoryItem
@onready var texture_rect: TextureRect = $TextureRect

@export var WhatCanHold : CanHoldWhat

enum CanHoldWhat{
	Anything,
	MeleeWeapons,
	RangedWeapons,
	Tools
}

func _ready() -> void:
	mouse_entered.connect(MouseEntered)
	mouse_exited.connect(MouseExited)

func MouseEntered():
	IsHovered = true
	if(AssocInvHud.GrabbedItemInstance):
		var shortiref : InventoryItem= AssocInvHud.GrabbedItemInstance.WhatItemAmI
		match WhatCanHold:
			CanHoldWhat.Anything:
				pass
			CanHoldWhat.MeleeWeapons:
				if(!shortiref.ItemAttributes.has(UnlimitedRulebook.ItemAttribute.MeleeWeapon)):
					return
			CanHoldWhat.RangedWeapons:
				if(!shortiref.ItemAttributes.has(UnlimitedRulebook.ItemAttribute.RangedWeapon)):
					return
			CanHoldWhat.Tools:
				if(!shortiref.ItemAttributes.has(UnlimitedRulebook.ItemAttribute.Tool)):
					return
		iteminslotref = AssocInvHud.GrabbedItemInstance.WhatItemAmI
		print(iteminslotref.ItemName)
		texture_rect.texture = iteminslotref.inventory_tex

func MouseExited():
	IsHovered = false
