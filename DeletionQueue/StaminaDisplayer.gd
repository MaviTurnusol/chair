extends ProgressBar

@export var StaminaComponentFather : Node
var StaminaComponent : StaminaComp
var TargetValue : float
@export var ChangeSpeed : float
func _ready() -> void:
	for i in StaminaComponentFather.get_children():
		if(i is StaminaComp):
			StaminaComponent = i
	max_value = StaminaComponent.MAX_STAMINA
	value = max_value
	TargetValue = value

func _process(delta: float) -> void:
	TargetValue = StaminaComponent.stamina
	value = move_toward(value,TargetValue,ChangeSpeed*delta)
