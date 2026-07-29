extends Area2D

var linear_velocity : Vector2
var Damage : float

func _ready() -> void:
	body_entered.connect(BodyEntered)
	area_entered.connect(AreaEntered)

func _physics_process(delta: float) -> void:
	global_position += linear_velocity * delta

func BodyEntered(body : Node2D):
	if(body.is_in_group("Bullet")):
		return
	print("BODYENTERED")
	queue_free()

func AreaEntered(area : Node2D):
	if(area.is_in_group("Bullet")):
		return
	if(area.has_method("TakeDamage")):
		area.TakeDamage(Damage)
	queue_free()
