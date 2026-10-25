extends Node2D

var targeting_player = true
var offset = Vector2(0, -80)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if targeting_player:
		if UnlimitedRulebook.player:
			if is_instance_valid(UnlimitedRulebook.player):
				global_position = UnlimitedRulebook.player.global_position + offset
	pass
