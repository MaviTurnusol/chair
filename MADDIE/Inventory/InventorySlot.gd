extends Control
class_name InventorySlot
@onready var texture_rect: TextureRect = $TextureRect
@export var onText : Texture2D
@export var offText : Texture2D
@export var abouttobeonText : Texture2D
var _inventorycomponent : InventoryComponent
var _inventoryHud : InventoryHud
var whatItemAmI : InventoryItem

func ShowActive():
	texture_rect.texture = onText

func ShowInactive():
	texture_rect.texture = offText

func ShowAboutToBeOn():
	texture_rect.texture = abouttobeonText

var IsHovered : bool

func _ready() -> void:
	mouse_entered.connect(MouseEntered)
	mouse_exited.connect(MouseExited)

func MouseEntered():
	IsHovered = true
	_inventoryHud.DisplayGrabbed(_inventoryHud.InventorySlotsDict.find_key(self),_inventorycomponent.OwnInventoryGrid)

func MouseExited():
	IsHovered = false
	if(_inventoryHud.GrabbedItemHoveredPosition==_inventoryHud.InventorySlotsDict.find_key(self)):
		_inventoryHud.GrabbedItemHoveredPosition = Vector2i(-1,-1)
		_inventoryHud.exitedGrid()
		_inventoryHud.DisplayInventoryGrid(_inventorycomponent.OwnInventoryGrid)

func _input(event: InputEvent) -> void:
	if(!IsHovered):
		return
	if(event.is_action_pressed("RightClick")):
		_inventorycomponent.DropItem(whatItemAmI)
	if(event.is_action_pressed("Click")):
		_inventoryHud.GrabItem(whatItemAmI)
