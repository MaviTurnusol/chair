extends Node2D
class_name Legger

@export var BossCore : Node2D

#@export var LegDetachDistance : float

var Legs : Array[LegUnit]

@export var PathFindingLayer : TileMapLayer

class LegUnit:
	#variables
	var LegDetachDistance : float = 400/2
	var MaxLength : float = 200#*2
	
	var LegMoveSpeed : float = 0
	var LegMinMoveSpeed : float = 24#256
	var LegMaxMoveSpeed : float = 1256#512
	var LegnessMidSkew : float = 1
	var LegSpacing : float = 128
	
	var LegAccel = 256*5#2
	
	var PathTiles : TileMapLayer
	
	#passed
	var Core : Node2D
	var LegLine : Line2D
	var PathSet : TileMapLayer
	var AllOtherLegs : Array[LegUnit]
	
	#found
	var DistanceFromCore : float
	var LegDistanceFromTarget : float = 9999
	var LegDistanceFromCore : float = 9999
	var DesiredTargetPoint : Vector2
	var DesiredKneePoint : Vector2
	var KneePoint : Vector2

	#Displayed
	var CurrentPoint : Vector2
	
	#States
	var isDetached : bool = true
	var IsNewTileFound : bool = false
	
	func _init(lineref,coreref,pathref) -> void:
		LegLine = lineref
		Core = coreref
		PathSet = pathref
		
		LegLine.add_point(Core.position)
		LegLine.add_point(Core.position)
		LegLine.add_point(Core.position)

	func _set_core_point():
		LegLine.points[0] = Core.position
	func _findMinDistanceToOtherLegsFromPoint(querypoint : Vector2):
		var disties : Array[float]
		for i in AllOtherLegs:
			var distie = i.DesiredTargetPoint.distance_to(querypoint)
			disties.append(distie)
		return disties.min()
	func _set_knee_point():
		LegLine.points[1] = KneePoint
	func _set_current_point():
		LegLine.points[2] = CurrentPoint
	func _FindKneePoint():
		var ExtraDistance = MaxLength - LegDistanceFromCore
		if(sign(ExtraDistance)<0):
			ExtraDistance = 0
		var DirToPoint = Core.position.direction_to(CurrentPoint)
		var Hypot = DirToPoint * (Core.position.distance_to(CurrentPoint))
		var Midpoint = (Hypot/2)
		Midpoint *= LegnessMidSkew
		var BendAngle
		#bendsleft 
		if(DesiredTargetPoint.x < Core.position.x):
			#goleft
			BendAngle = deg_to_rad(90)#-Midpoint.rotated(deg_to_rad(90)).angle()
			pass
		else:
			BendAngle = deg_to_rad(-90) #Midpoint.rotated(deg_to_rad(90)).angle()
			#goright
			pass
		DesiredKneePoint =  Core.position + Midpoint + (ExtraDistance * DirToPoint.rotated(BendAngle))
	
	func SetOtherLegs(OtherLegs):
		for i in OtherLegs:
			if(i!=self):
				AllOtherLegs.append(i)
		FindNewTargetPoint()
	
	func _FindDistanceFromCore():
		DistanceFromCore = Core.position.distance_to(DesiredTargetPoint)
	func _FindLegDistanceFromCore():
		LegDistanceFromCore = Core.position.distance_to(DesiredTargetPoint)
	func _FindLegDistanceFromTarget():
		LegDistanceFromTarget = CurrentPoint.distance_to(DesiredTargetPoint)
	func Update(delta : float):
		_FindDistanceFromCore()
		#p rint(LegDistanceFromTarget)
		_FindKneePoint()
		_FindLegDistanceFromTarget()
		_FindLegDistanceFromCore()
		_set_core_point()
		_set_current_point()
		_set_knee_point()
		#print(DistanceFromCore)
		KneePoint = KneePoint.move_toward(DesiredKneePoint,LegMoveSpeed*delta)
		if(!isDetached):
			if(DistanceFromCore > LegDetachDistance):
				Detach()
				if(!IsNewTileFound):
					IsNewTileFound = true
					FindNewTargetPoint()
		else:
			if(LegDistanceFromTarget < 8):
				Attach()
			else:
				#if(KneePoint.distance_to(DesiredKneePoint)>8):
				LegMoveSpeed = clampf(LegMoveSpeed,LegMinMoveSpeed,LegMaxMoveSpeed)
				LegMoveSpeed = move_toward(LegMoveSpeed,LegMaxMoveSpeed,LegAccel*delta)
				
				CurrentPoint = CurrentPoint.move_toward(DesiredTargetPoint,LegMoveSpeed*delta)
	func Detach():
		isDetached = true
		LegMoveSpeed = LegMinMoveSpeed
	func FindNewTargetPoint():
		#DesiredTargetPoint = Vector2(randf_range(-LegDetachDistance,LegDetachDistance),randf_range(-LegDetachDistance,LegDetachDistance)).clamp(Vector2(-LegDetachDistance,LegDetachDistance),Vector2(LegDetachDistance,LegDetachDistance))
		var TileSize : float = 64
		var TileDictionary : Dictionary[Vector2i,int]
		for tile in PathSet.get_used_cells():
			var tileweight : int = 0
			#tileweight = randi_range(1,12)# randiomensees
			var TilePos = LegLine.get_parent().to_local((PathSet.to_global(Vector2(tile)+Vector2(0.5,0.5))*TileSize))
			var DistanceToTile = Core.position.distance_to(TilePos)
			if(DistanceToTile>LegDetachDistance):
				tileweight = 9999
			if(_findMinDistanceToOtherLegsFromPoint(TilePos)<LegSpacing):
				tileweight += 5
			TileDictionary[tile] = tileweight
		
		var TargetValue = TileDictionary.values().min()
		var TargetTileVector
		var AllPossibleTargetTiles : Array[Vector2i]
		for Tile in TileDictionary:
			if(TileDictionary[Tile]<=TargetValue):
				AllPossibleTargetTiles.append(Tile)
		TargetTileVector = AllPossibleTargetTiles.pick_random()
		
		DesiredTargetPoint = LegLine.get_parent().to_local((PathSet.to_global(Vector2(TargetTileVector)+Vector2(0.5,0.5))*TileSize))
		pass

	func Attach():
		CurrentPoint = DesiredTargetPoint
		isDetached = false
		IsNewTileFound = false
func _ready() -> void:
	var LegSet : Array[LegUnit]
	for i in get_children():
		if(i is Line2D):
			LegSet.append(LegUnit.new(i,BossCore,PathFindingLayer))
	for i in LegSet:
		i.SetOtherLegs(LegSet)
	Legs = LegSet

func _process(delta: float) -> void:
	for Leg in Legs:
		Leg.Update(delta)
		pass

func GetPercentOfLegsAttached():
	var am = 0.0
	for leg in Legs:
		if(!leg.isDetached):
			am+=1.0
	return am/Legs.size()

func GetLegByIndex(index : int):
	return Legs[index]
