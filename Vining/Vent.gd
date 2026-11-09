extends Node2D
class_name Vent
@export var InitialRotation : float

var IsVentVineActive : bool = false
@onready var OwnVentVine : Line2D = $VentVine

@onready var VentRoom = get_tree().get_first_node_in_group("ventroom")

var DefaultZ
var isescaping = false
# Called when the node enters the scene tree for the first time.
func _ready():
	DefaultZ = z_index
	OwnVentVine.DefRotation = (InitialRotation)
	
	#MakeVineInvisible
	OwnVentVine.visible = false
	OwnVentVine.set_process(false)

#STOLEN FROM DOOR CODE
var onCooldown = false

func action():
	if !onCooldown && !IsVentVineActive:
		StartVenting()
		onCooldown = true
		StartCoolDown()
		print("YAY!")
		UnlimitedRulebook.player.velocity = Vector2.ZERO
	#if(event.is_action_pressed("return_to_body")&&OwnVentVine.visible&&OwnVentVine.GrowthDirection!=OwnVentVine.GrowthStates.Recalling):
		#OwnVentVine.EMERGENCYRECALL()

func StartCoolDown():
	await get_tree().create_timer(1.2).timeout
	onCooldown = false

func StartVenting():
	#Call Function In Player
	UnlimitedRulebook.player.StartVenting()
	
	#MakeVineVisible
	IsVentVineActive = true
	OwnVentVine.visible = true
	OwnVentVine.set_process(true)
	
	#Tween in the vents visibility
	VentRoom.TryShow()
	
	#TweenCamera
	for i in (OwnVentVine.get_children(false)):
		if(i.has_method("TweenCameraToPosition")):
			i.TweenCameraToPosition()
	pass

func ExitVentAtStart():
	#ExitAtStart
	ExitVent()
	UnlimitedRulebook.player.StopVenting(null)
	#TWEEN CAMERA
	for i in (OwnVentVine.get_children(false)):
		if(i.has_method("UnCamera")):
			i.UnCamera(false)
	pass
func ExitVentAtNewPosition(AtWhatPosition : Vector2):
	ExitVent()
	UnlimitedRulebook.player.StopVenting(AtWhatPosition)
	#TWEEN CAMERA
	for i in (OwnVentVine.get_children(false)):
		if(i.has_method("UnCamera")):
			i.UnCamera(true)
func ExitVent():
	
	#MakeVineInVisible
	IsVentVineActive = false
	OwnVentVine.GrowthDirection = OwnVentVine.GrowthStates.Stationary
	OwnVentVine.visible = false
	OwnVentVine.set_process(false)
	#Tween out the vents visibility
	if(!isescaping):
		VentRoom.TryHide()
	else:
		isescaping = false
	
func EmergencyExit():
	isescaping = true
	
	for i in (OwnVentVine.get_children(false)):
		if(i.has_method("UnCamera")):
			i.UnCamera(false)
	
	VentRoom.TryHide()
	UnlimitedRulebook.player.StopVenting(null)
	pass
