extends Sprite2D

var text : NoiseTexture2D

func _ready() -> void:
	text = texture
var elapsed : float = 0
var timeMult : float = 0.1
func _process(delta: float) -> void:
	elapsed += delta * timeMult
	text.noise.fractal_gain = 0.5 + (sin(elapsed)/4)
