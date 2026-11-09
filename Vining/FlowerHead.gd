extends Sprite2D

@onready var LineParent :Line2D = get_parent()
@onready var CollisionDetector : Area2D = $Area2D
@export var VentZoom : float = 1.5

var CanGoForward : bool = true

func _ready() -> void:
	CollisionDetector.connect("area_entered",AreaDetected)

func AreaDetected(area : Area2D):
	if(!area.get_parent() is Vent):
		return
	if(area!=get_parent().get_parent().get_node("VentCollisionPointForVining")):
		get_parent().ExitVentAtNewVent(area)
		print(area.global_position)
		position = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation = deg_to_rad(LineParent.CurrentRotationDegrees)
	if(LineParent.points.size()!=0):
		position = LineParent.get_point_position(LineParent.points.size()-1)
	
	if(LineParent.visible):
		if(LineParent.GrowthDirection != LineParent.GrowthStates.Recalling):
			#get_tree().get_first_node_in_group("player").get_node("Camera2D").position = position + Vector2(0,48)
			#UnlimitedRulebook.cam #TRAKCHERE
			pass
	CanGoForward = CollisionDetector.has_overlapping_bodies()
	if(!CanGoForward && LineParent.GrowthDirection == LineParent.GrowthStates.Elongating):
		LineParent.GrowthDirection = LineParent.GrowthStates.Stationary
		pass

var defzoom : float

func TweenCameraToPosition():
	##if($Camera2D.enabled == false):
	#global_position = get_tree().get_first_node_in_group("player").global_position
	#
	#$Camera2D.enabled = true
	#$Camera2D.make_current()
	UnlimitedRulebook.cam.target = self
	
	defzoom = UnlimitedRulebook.cam.targetzoom
	var TweenOut = get_tree().create_tween()
	TweenOut.tween_property(UnlimitedRulebook.cam,"targetzoom",VentZoom,1)

func UnCamera(AtNewPos : bool):
	UnlimitedRulebook.cam.target = UnlimitedRulebook.player.get_node("camTarget")
	
	var TweenOut = get_tree().create_tween()
	TweenOut.tween_property(UnlimitedRulebook.cam,"targetzoom",defzoom,1)
	
	#$Camera2D.enabled = false
	#$Camera2D.zoom = Vector2(3,3)
