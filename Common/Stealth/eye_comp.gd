extends Node

@export var father : Node

@export var SightRange : float = 100
@export var HideRange : float = 50
var EyeRay : RayCast2D
var HideShape : ShapeCast2D

var CanSeeEvil : bool = true

func _ready() -> void:
	EyeRay = RayCast2D.new()
	EyeRay.collision_mask = 32+1
	EyeRay.hit_from_inside = true
	HideShape = ShapeCast2D.new()
	HideShape.target_position = Vector2.ONE
	HideShape.shape = CircleShape2D.new()
	HideShape.shape.radius = HideRange
	add_child(EyeRay)
	add_child(HideShape)

func _process(delta: float) -> void:
	EyeRay.global_position = father.global_position - Vector2(16,16)
	EyeRay.target_position = father.global_position.direction_to(UnlimitedRulebook.player.global_position-Vector2(16,16))
	EyeRay.target_position *= SightRange
	if(sign(EyeRay.target_position.x)!=sign(father.dir)):
		EyeRay.target_position *= -1
	HideShape.global_position = father.global_position
	HideShape.force_shapecast_update()
	if(HideShape.is_colliding()):
		#print(HideShape.collision_result)
		CanSeeEvil = true
		for i in range(0,HideShape.get_collision_count()):
			if(UnlimitedRulebook.player == HideShape.get_collider(i)):
				CanSeeEvil = false
				#print("HIDDEN")
				break
	else:
		CanSeeEvil = true
	if(CanSeeEvil):
		if(EyeRay.is_colliding()):
			if(UnlimitedRulebook.player == EyeRay.get_collider()):
				#print("SEEN")
				see_target()


func see_target():
	if father:
		if father.has_method("SpotTarget"):
			father.SpotTarget()
			#print("SAW TARGET")
