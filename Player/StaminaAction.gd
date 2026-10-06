extends Node

@export var StaminaRequired : float = 0
@export var MinStaminaToPerform : float = 0
@export var StamComp : StaminaComp
@export var ReduceStaminaOnStart : bool = true
@export var DoForceAStateChange : bool = true
@export var DrainStaminaRate : float = 0
@export var StateToReturnAfterDrainingStamina : String = "idle"
var ParentState : State
var AllStates : PackedStringArray
var DefaultCant

var isActiveState : bool = false
func _ready() -> void:
	ParentState = get_parent()
	DefaultCant = ParentState.cantTransitionFrom
	for i in get_parent().get_parent().get_children():
		if(i is State):
			var nam = i.name.substr(0,1).to_lower()+i.name.substr(1)
			AllStates.append(nam)

func _process(delta: float) -> void:
	if(ParentState.get_parent().currentState == ParentState&&!isActiveState):
		isActiveState = true
		if(ReduceStaminaOnStart):
			StamComp.ReduceStamina(StaminaRequired)
	elif(ParentState.get_parent().currentState!=ParentState):
		isActiveState = false
	
	if(isActiveState):
		StamComp.ReduceStamina(DrainStaminaRate*delta)
	
	if(StamComp.stamina < StaminaRequired):
		ParentState.cantTransitionFrom = AllStates
		if(DoForceAStateChange):
			if(StamComp.stamina <= MinStaminaToPerform):
				ParentState.machine.change_state_to(StateToReturnAfterDrainingStamina)
	else:
		ParentState.cantTransitionFrom = DefaultCant
		
