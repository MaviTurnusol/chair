extends Node
class_name InventoryComponent 

@export var InventorySize : Vector2i = Vector2i(4,4)
@export var OwnInventoryGrid : InventoryGrid
var BodyRef : Node2D
@export var inventory_hud: InventoryHud
@onready var PickupableItemScene : PackedScene = preload("uid://52s8lsucji0v")
@export var StartItems : Array[InventoryItem]
@export var OwnerBody : Node2D
signal ItemAddedToInventory

func _ready() -> void:
	#if(!LoadedInv):
	#print("I DID DO")
	var CloneGrid : InventoryGrid
	if(OwnInventoryGrid!=null):
		CloneGrid = OwnInventoryGrid.duplicate()
	
	OwnInventoryGrid = InventoryGrid.new(InventorySize)
	
	OwnInventoryGrid.UpdateInventoryDict()
	
	await get_tree().process_frame
	if(!CloneGrid):
		for i in StartItems:
			AddItemToInventory(i)
	else:
		for i in CloneGrid.ItemsInInv:
			AddItemToInventory(i)
	inventory_hud.visible = true
	await get_tree().process_frame
	OwnInventoryGrid.UpdateInventoryDict()
	inventory_hud.DisplayInventoryGrid(OwnInventoryGrid)
	await get_tree().process_frame
	inventory_hud.visible = false

func AddItemToInventory(_NewItem : InventoryItem):
	#ItemsInInventory.append(_NewItem)
	#print(ItemsInInventory)
	var IsSuccessful = OwnInventoryGrid.TryAddNewItemToInventory(_NewItem)
	OwnInventoryGrid.UpdateInventoryDict()
	inventory_hud.DisplayInventoryGrid(OwnInventoryGrid)
	inventory_hud.RefreshInventoryItemSprites()
	if(!IsSuccessful):
		DropItem(_NewItem)
	else:
		ItemAddedToInventory.emit()
	

func DropItem(_WhatItem : InventoryItem):
	if(_WhatItem in OwnInventoryGrid.ItemsInInv):
		OwnInventoryGrid.ItemsInInv.erase(_WhatItem)
	var NewPickupable = PickupableItemScene.instantiate()
	NewPickupable.WhatItemAmI = _WhatItem
	NewPickupable.global_position = OwnerBody.global_position #get_parent().global_position
	#get_parent().add_sibling(NewPickupable)
	OwnerBody.add_sibling(NewPickupable)
	Refresh()

func RemoveItem(_WhatItem : InventoryItem):
	if(_WhatItem in OwnInventoryGrid.ItemsInInv):
		OwnInventoryGrid.ItemsInInv.erase(_WhatItem)
	Refresh()
#func ReleaseItem(_where : Vector2i):
	#HeldItem.Position = _whereAddItemToInventory()

func Refresh():
	OwnInventoryGrid.UpdateInventoryDict()
	inventory_hud.DisplayInventoryGrid(OwnInventoryGrid)
