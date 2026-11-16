extends Area2D
class_name HidePoint

var hidable : bool = false

@export var BackAgainst : BackDirections = BackDirections.Left

enum BackDirections{
	Left = -1,
	Right = 1
}

func _ready() -> void:
	area_entered.connect(HideAreaEntered)
	area_exited.connect(HideAreaExited)

func HideAreaEntered(Enterer : Node):
	if(Enterer is ActionableFinder):
		hidable = true
	pass

func HideAreaExited(Enterer : Node):
	if(Enterer is ActionableFinder):
		hidable = false
	pass

func _input(event: InputEvent) -> void:
	if(hidable):
		if(event.is_action_pressed("down")):
			get_parent().Activate()
			UnlimitedRulebook.player.marker_2d.scale.x = BackAgainst
			UnlimitedRulebook.player.global_position.x = global_position.x
