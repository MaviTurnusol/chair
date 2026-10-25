extends Camera2D

@export var CameraShakeProfile : ShakeProfile
@onready var camera_shake: CameraShake = $CameraShake
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera_shake.shake(CameraShakeProfile)
