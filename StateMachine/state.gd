extends Node

class_name State

var stateOwner
var machine

@export var animName = ""
@export var animOnStart = true
@export var endWithAnim = false

@export var cantTransitionFrom : PackedStringArray
@export var cantTransitionTo : PackedStringArray
@export var canOnlyTransitionTo : PackedStringArray

func SuperStart():
	if animOnStart:
		if stateOwner:
			if is_instance_valid(stateOwner.anima):
				stateOwner.anima.play(animName)
				#print("i played animation: " + stateOwner.anima.animation)
				if !endWithAnim:
					return
	if endWithAnim:
		if stateOwner:
			if is_instance_valid(stateOwner.anima):
				if !stateOwner.anima.animation_finished.is_connected(AnimSuperEnd):
					stateOwner.anima.animation_finished.connect(AnimSuperEnd)
					#print("endanim connected: " + stateOwner.anima.animation)
				return
	await get_tree().process_frame
	SuperStart()
	return

func Start():
	pass

func End():
	pass

func AnimSuperEnd():
	if stateOwner:
		if is_instance_valid(stateOwner.anima):
			if stateOwner.anima.animation == animName:
				if stateOwner.anima.visible:
					machine.change_state_to(machine.initialState.name.to_lower())
				
func Process(delta):
	pass

func PhysicsProcess(delta):
	pass
