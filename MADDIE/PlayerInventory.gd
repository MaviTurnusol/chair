extends Node
@onready var player_inventory_displayer: InventoryHud = $PlayerInventoryDisplayer
@onready var inventorycontrol: Control = $PlayerInventoryDisplayer/Control/Inventory

var ToggleTween : Tween
func ShowInventory():
	if(ToggleTween):
		ToggleTween.kill()
	ToggleTween = get_tree().create_tween()
	player_inventory_displayer.visible = true
	ToggleTween.set_trans(Tween.TRANS_SINE)
	ToggleTween.tween_property(inventorycontrol,"scale",Vector2.ONE,0.25)
	IsActive = true

func HideInventory():
	if(ToggleTween):
		ToggleTween.kill()
	ToggleTween = get_tree().create_tween()
	ToggleTween.tween_property(inventorycontrol,"scale",Vector2.ZERO,0.25)
	ToggleTween.set_trans(Tween.TRANS_SINE)
	ToggleTween.tween_property(player_inventory_displayer,"visible",false,0)
	IsActive = false

var IsActive : bool
func ToggleInventory():
	if(IsActive):
		HideInventory()
	else:
		ShowInventory()

func _ready() -> void:
	IsActive = player_inventory_displayer.visible
