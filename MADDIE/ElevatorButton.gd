extends Node2D

var ElevatorableRooms : Array[Room]
@onready var grid_container: GridContainer = $CanvasLayer/Control/GridContainer
@onready var ElevatorCanvasLayer: CanvasLayer = $CanvasLayer
@export var ElevatorDoor : Node2D
func _ready() -> void:
	#var idx = 0
	for i in SceneManager.RoomDict.values():
		var newelevatorbutton : Button = Button.new()
		grid_container.add_child(newelevatorbutton)
		ElevatorableRooms.append(i)
		newelevatorbutton.text = i.Name
		newelevatorbutton.pressed.connect(ButtonPressed.bind(i.Name))
		#idx+=1
		print(i.Name)

func ButtonPressed(whichbuttonName : String):
	ElevatorDoor.TargetSceneName = whichbuttonName
	ElevatorCanvasLayer.visible = false

func action():
	ElevatorCanvasLayer.visible = !ElevatorCanvasLayer.visible

#func _process(delta: float) -> void:
	#if(UnlimitedRulebook.player):
		#if(UnlimitedRulebook.player.global_position.distance_to(global_position)>PlayerMaxRange):
			#InventoryDisplayer.visible = false
