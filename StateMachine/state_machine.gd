extends Node

@export var initialState : State
var currentState : State : set = set_state
var prevState : State

func set_state(value):
	if value == currentState:
		return
	if !value || !is_instance_valid(value):
		return
	if currentState:
		var foo = str(currentState.name)
		if currentState.cantTransitionTo.has(value.name):
			return
		if value.cantTransitionFrom.has(foo[0].to_lower() + foo.substr(1)):
			return
		if currentState.canOnlyTransitionTo.size() > 0:
			if !currentState.canOnlyTransitionTo.has(str(value.name)[0].to_lower() + str(value.name).substr(1)):
				print(value.name)
				print(currentState.canOnlyTransitionTo)
				return
	value.SuperStart()
	value.Start()
	if currentState:
		prevState = currentState
		currentState.End()
	currentState = value

func _ready():
	for state in get_children():
		if state is State:
			state.stateOwner = get_parent()
			state.machine = self
	currentState = initialState

func _process(delta):
	if !currentState:
		return
	currentState.Process(delta)

func _physics_process(delta):
	if !currentState:
		return
	currentState.PhysicsProcess(delta)

func change_state_to(state):
	if !currentState || !state:
		return
	currentState = get_node(state[0].to_upper() + state.substr(1))
	print("changed via chage_state_to(): " + currentState.name)

func get_state():
	if currentState:
		if is_instance_valid(currentState):
			var foo = str(currentState.name)
			return foo[0].to_lower() + foo.substr(1)
	return null

func get_previous_state():
	if prevState:
		if is_instance_valid(prevState):
			return prevState.name.to_lower()
	return null
