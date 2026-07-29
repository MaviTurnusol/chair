extends Node2D

@onready var hit_box: Area2D = $HitBox

var linear_velocity : Vector2
var Damage : float:
	set(value):
		Damage = value
		hit_box.atk = Damage

func _ready() -> void:
	hit_box.harmed.connect(DealtDamage)

func DealtDamage():
	hit_box.queue_free()

func _physics_process(delta: float) -> void:
	global_position += linear_velocity * delta
