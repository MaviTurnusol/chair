extends Node
class_name InventoryComponent 

@export var InventorySize : Vector2i = Vector2i(4,4)
var OwnInventoryGrid : InventoryGrid
var BodyRef : Node2D
@export var inventory_hud: InventoryHud
@onready var PickupableItemScene : PackedScene = preload("uid://52s8lsucji0v")
@export var StartItems : Array[InventoryItem]
func _ready() -> void:
	OwnInventoryGrid = InventoryGrid.new(InventorySize)
	OwnInventoryGrid.UpdateInventoryDict()
	await get_tree().process_frame
	for i in StartItems:
		AddItemToInventory(i)
	await get_tree().process_frame
	inventory_hud.DisplayInventoryGrid(OwnInventoryGrid)

func AddItemToInventory(_NewItem : InventoryItem):
	#ItemsInInventory.append(_NewItem)
	#print(ItemsInInventory)
	var IsSuccessful = OwnInventoryGrid.TryAddNewItemToInventory(_NewItem)
	OwnInventoryGrid.UpdateInventoryDict()
	inventory_hud.DisplayInventoryGrid(OwnInventoryGrid)
	inventory_hud.RefreshInventoryItemSprites()
	if(!IsSuccessful):
		DropItem(_NewItem)
	

func DropItem(_WhatItem : InventoryItem):
	if(_WhatItem in OwnInventoryGrid.ItemsInInv):
		OwnInventoryGrid.ItemsInInv.erase(_WhatItem)
	var NewPickupable = PickupableItemScene.instantiate()
	NewPickupable.WhatItemAmI = _WhatItem
	NewPickupable.global_position = get_parent().global_position
	get_parent().add_sibling(NewPickupable)
	Refresh()

#func ReleaseItem(_where : Vector2i):
	#HeldItem.Position = _whereAddItemToInventory()

func Refresh():
	OwnInventoryGrid.UpdateInventoryDict()
	inventory_hud.DisplayInventoryGrid(OwnInventoryGrid)
