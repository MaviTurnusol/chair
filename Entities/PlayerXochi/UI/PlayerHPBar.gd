extends Control
@onready var progress_bar: TextureProgressBar = $Node2D/ProgressBar
@onready var left_dragon: AnimatedSprite2D = $Node2D/LeftDragon
@onready var right_dragon: AnimatedSprite2D = $Node2D/RightDragon

var rightmaxpos : float

func _process(delta: float) -> void:
	var lastrdp = right_dragon.position.x
	right_dragon.position.x = (progress_bar.value / progress_bar.max_value) * progress_bar.size.x 
	if(lastrdp!=right_dragon.position.x):
		if(right_dragon.animation!="chomp"):
			right_dragon.play("chomp")
		pass
	if(!right_dragon.is_playing()):
		right_dragon.play("default")
