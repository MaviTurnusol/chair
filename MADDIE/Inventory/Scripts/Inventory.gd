extends CanvasLayer
class_name InventoryHud

var InventorySlotsDict : Dictionary[Vector2i,InventorySlot]
@onready var grid_container: GridContainer = $Control/Inventory/GridContainer
@onready var InventorySlotScene : PackedScene = preload("uid://dprud6reoi3k6")
@onready var GrabbedItemScene : PackedScene = preload("uid://bqb0nyrevwg5i")
@export var _InventoryComponent : InventoryComponent
var gridslotsize : Vector2
#Sconst PixelsPerSlot : Vector2 = Vector2(86,86)
var InventoryItemSprites : Array

@onready var inventory_control : Control = $Control/Inventory

func _ready() -> void:
	grid_container.columns = _InventoryComponent.InventorySize.x
	gridslotsize = grid_container.size / Vector2(_InventoryComponent.InventorySize)
	for i in range(0,_InventoryComponent.InventorySize.x * _InventoryComponent.InventorySize.y):
		var newslot = InventorySlotScene.instantiate()
		newslot._inventorycomponent = _InventoryComponent
		newslot._inventoryHud = self
		
		newslot.custom_minimum_size = gridslotsize
		grid_container.add_child(newslot)
	
	inventory_control.mouse_entered.connect(HoverThisInventory)
	
	
	var slotveclocation : Vector2i = Vector2i.ZERO
	for islot in grid_container.get_children():
		InventorySlotsDict[slotveclocation] = islot
		slotveclocation += Vector2i.RIGHT
		if(slotveclocation.x >= _InventoryComponent.InventorySize.x):
			slotveclocation += Vector2i.DOWN
			slotveclocation.x = 0
	
	gridslotsize = grid_container.get_child(0).size
	
	#PASS UI SUBVIEWPORT SCALING FIX
	await get_tree().process_frame
	reparent(get_tree().root)

func HoverThisInventory():
	UnlimitedRulebook.HoveredInventory = _InventoryComponent

func _process(delta: float) -> void:
	if(GrabbedItem):
		if(UnlimitedRulebook.HoveredInventory==null):
			HoverThisInventory()
		if(UnlimitedRulebook.HoveredInventory != _InventoryComponent):
			UnlimitedRulebook.HoveredInventory.inventory_hud.TransferOwnerShipOfGrabbedItem(GrabbedItem,GrabbedItemInstance)
			GrabbedItem = null
			#GrabbedItemInstance.queue_free()
			#GrabbedItem = null
	
func TransferOwnerShipOfGrabbedItem(newGrabbedItem : InventoryItem,newgrabbedInstance : Control):
	GrabbedItem = newGrabbedItem
	GrabbedItemInstance = newgrabbedInstance
	GrabbedItemInstance.reparent(grid_container.get_parent())
	

func _input(event: InputEvent) -> void:
	
	if(GrabbedItem):
		if(Input.is_action_just_released("Click")):
			if(IsGrabbedPositionValid):
				var IsSuccessful = _InventoryComponent.OwnInventoryGrid.AddItemAtPosition(GrabbedItem,GrabbedItemHoveredPosition)
				if(!IsSuccessful):
					_InventoryComponent.DropItem(GrabbedItem)
			else:
				_InventoryComponent.DropItem(GrabbedItem)
			GrabbedItemInstance.queue_free()
			GrabbedItem = null
			_InventoryComponent.Refresh()
	
		if(event.is_action_pressed("RotateItem")):
			GrabbedItem.RotateItem()
			DisplayGrabbed(GrabbedItemHoveredPosition,_InventoryComponent.OwnInventoryGrid)

func DisplayInventoryGrid(GridToDisplay : InventoryGrid):
	#print(InventorySlotsDict)
	for pos in GridToDisplay.InventoryDict.keys():
		if(GridToDisplay.InventoryDict[pos]!=null):
			InventorySlotsDict[pos].ShowActive()
			InventorySlotsDict[pos].whatItemAmI = GridToDisplay.InventoryDict[pos]
		else:
			InventorySlotsDict[pos].ShowInactive()
			InventorySlotsDict[pos].whatItemAmI = null
	
	RefreshInventoryItemSprites()

func RefreshInventoryItemSprites():
	for spr in InventoryItemSprites.duplicate():
		InventoryItemSprites.erase(spr)
		spr.queue_free()
	
	InventoryItemSprites.clear()
	for item in _InventoryComponent.OwnInventoryGrid.ItemsInInv:
		if(item.inventory_tex):
			var newspr = Sprite2D.new()
			newspr.texture = item.inventory_tex
			#print((gridslotsize/PixelsPerSlot))
			newspr.scale = Vector2.ONE * item.inv_scalemulti #* (gridslotsize/PixelsPerSlot)
			newspr.z_index = 2
			newspr.position = InventorySlotsDict[item.Position].position
			var meanoffset : Vector2 = Vector2.ZERO
			for p in item.ShapePoints:
				meanoffset += Vector2(p)
			meanoffset = meanoffset/item.ShapePoints.size()
			newspr.global_position += (Vector2(0.5,0.5)*gridslotsize) + (meanoffset * gridslotsize)
			#print(meanoffset)
			newspr.rotation_degrees = item.RotationState
			grid_container.add_sibling(newspr)
			InventoryItemSprites.append(newspr)

var GrabbedItem : InventoryItem
var GrabbedItemInstance : Control
func GrabItem(_WhatItem : InventoryItem):
	if(_WhatItem in _InventoryComponent.OwnInventoryGrid.ItemsInInv):
		_InventoryComponent.OwnInventoryGrid.ItemsInInv.erase(_WhatItem)
		GrabbedItem = _WhatItem
		_InventoryComponent.OwnInventoryGrid.UpdateInventoryDict()
		DisplayInventoryGrid(_InventoryComponent.OwnInventoryGrid)
		RefreshInventoryItemSprites()
		CreateGrabbedItem(_WhatItem)
		DisplayGrabbed(_WhatItem.Position,_InventoryComponent.OwnInventoryGrid)

func CreateGrabbedItem(_WhatItem : InventoryItem):
	if(GrabbedItemInstance):
		_InventoryComponent.DropItem(GrabbedItemInstance.WhatItemAmI)
		GrabbedItemInstance.queue_free()
	GrabbedItemInstance = GrabbedItemScene.instantiate()
	GrabbedItemInstance.WhatItemAmI = _WhatItem
	grid_container.add_sibling(GrabbedItemInstance)
	pass

var IsGrabbedPositionValid : bool
var GrabbedItemHoveredPosition : Vector2i
func DisplayGrabbed(HoveredWhere : Vector2i,GridToDisplay : InventoryGrid):
	if(GrabbedItem!=null):
		var isvalid : bool = true
		for p in GrabbedItem.ShapePoints:
			if(!InventorySlotsDict.has(HoveredWhere + p)):
				isvalid = false
				break
			if(GridToDisplay.InventoryDict[HoveredWhere+p]!=null):
				isvalid = false
				break
		DisplayInventoryGrid(GridToDisplay)
		if(isvalid):
			for p in GrabbedItem.ShapePoints:
				if(InventorySlotsDict.has(HoveredWhere + p)):
					InventorySlotsDict[HoveredWhere + p].ShowAboutToBeOn()
		else:
			for p in GrabbedItem.ShapePoints:
				if(InventorySlotsDict.has(HoveredWhere + p)):
					InventorySlotsDict[HoveredWhere + p].ShowActive()
		IsGrabbedPositionValid = isvalid
		GrabbedItemHoveredPosition = HoveredWhere
		var meanoffset : Vector2 = Vector2.ZERO
		
		if(isvalid):
			for p in GrabbedItem.ShapePoints:
				meanoffset += Vector2(p)
			meanoffset = meanoffset/GrabbedItem.ShapePoints.size()
			var targ = (Vector2(0.5,0.5)*gridslotsize) + (meanoffset * gridslotsize)
			if(GrabbedItemInstance):
				GrabbedItemInstance.SetTargetPos(InventorySlotsDict[HoveredWhere].global_position + targ)



func exitedGrid():
	if(GrabbedItemInstance):
		GrabbedItemInstance.isPosSet = false
