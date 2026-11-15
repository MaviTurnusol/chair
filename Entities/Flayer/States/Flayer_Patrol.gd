extends State

var ChosenPath : Path2D
@export var MoveSpeed : float = 100
var isOnChosenPath : bool = false
func Start():
	if(stateOwner.enemyPreps):
		ChosenPath = stateOwner.enemyPreps.get_node("FlayerPaths").get_children().pick_random()
	else:
		await get_tree().process_frame
		ChosenPath = stateOwner.enemyPreps.get_node("FlayerPaths").get_children().pick_random()
func Process(delta):
	var targetPoint : Vector2
	
	if(ChosenPath):
		if(stateOwner.global_position.distance_to(ChosenPath.curve.get_closest_point(stateOwner.global_position))>5):
			targetPoint = ChosenPath.curve.get_closest_point(stateOwner.global_position)
			isOnChosenPath = false
		else:
			isOnChosenPath = true
	
	if(isOnChosenPath):
		var closestOffset = ChosenPath.curve.get_closest_offset(stateOwner.global_position)
		var nextOffset 
		if(ChosenPath.curve.get_baked_length() < closestOffset + 5):
			nextOffset = ChosenPath.curve.sample_baked(0)
		else:
			nextOffset = ChosenPath.curve.sample_baked(closestOffset + 5)
		
		targetPoint = nextOffset
		#if()okakjsfjnasjfnas
	
	if(targetPoint):
		stateOwner.velocity = stateOwner.global_position.direction_to(targetPoint) * MoveSpeed
	else:
		stateOwner.velocity = Vector2.ZERO
	
	stateOwner.dir = sign(stateOwner.velocity.x)
	
	stateOwner.move_and_slide()
