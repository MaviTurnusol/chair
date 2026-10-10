extends Node
class_name StaminaComp
@export var MAX_STAMINA : float
var stamina : float : set = set_health
@export var father : Node
@export var StaminaRegainRate : float = 10
signal staminaChanged(oldVal, newVal)

func set_health(value):
	if value >= MAX_STAMINA:
		value = MAX_STAMINA
	#if value <= 0:
		#value = 0
		#if father:
			#if father.has_method("death"):
				#father.death()
	if value != stamina:
		staminaChanged.emit(stamina, value)
		stamina = value

func _process(delta: float) -> void:
	stamina += StaminaRegainRate*delta

func _ready():
	stamina = MAX_STAMINA

func ReduceStamina(drain)->bool:
	if(stamina - drain < 0):
		return false
	stamina -= drain
	if(stamina<0):
		stamina = 0
		return false
	else:
		return true
