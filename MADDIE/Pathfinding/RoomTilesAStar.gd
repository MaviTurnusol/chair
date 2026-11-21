@icon("res://TilemapExporter/GreyboxTiles/GreyboxTiles.png")
extends TileMapLayer
class_name RoomTilesAStar

var Grounded_ASTAR : AStar2D = AStar2D.new()
var Flight_ASTAR : AStar2D = AStar2D.new()

func _ready() -> void:
	CreateGroundedASTAR()
	#CreateFlightASTAR()
	ViusaliseAstar(Grounded_ASTAR)
	pass

func CreateGroundedASTAR():
	var size = get_used_rect().size
	Grounded_ASTAR.reserve_space(size.x*size.y)
	
	#Make All walls
	for i in size.x:
		for j in size.y:
			var idx = getAStarCellId(Vector2(i,j))
			Grounded_ASTAR.add_point(idx, to_global(map_to_local((Vector2(i,j)))))
	
	var wallcells = get_used_cells()
	
	for X in size.x:
		for Y in size.y:
			if(!Vector2i(X,Y) in wallcells):
				if(get_neighbor_cell(Vector2i(X,Y),TileSet.CELL_NEIGHBOR_BOTTOM_SIDE) in wallcells):
					for n in get_surrounding_cells(Vector2i(X,Y)):
						if(!n in wallcells):
							if(get_neighbor_cell(n,TileSet.CELL_NEIGHBOR_BOTTOM_SIDE) in wallcells):
								var idx = getAStarCellId(Vector2i(X,Y))
								var neighbouridx = getAStarCellId(n)
								if(Grounded_ASTAR.has_point(neighbouridx)):
									Grounded_ASTAR.connect_points(idx,neighbouridx, true)
	
	
	
	ConnectDoorsIntraScene(Grounded_ASTAR)

func CreateFlightASTAR():
	var size = get_used_rect().size
	Flight_ASTAR.reserve_space(size.x*size.y)
	
	for i in size.x:
		for j in size.y:
			var idx = getAStarCellId(Vector2(i,j))
			Flight_ASTAR.add_point(idx, to_global(map_to_local((Vector2(i,j)))))
	
	var wallcells = get_used_cells()
	for X in size.x:
		for Y in size.y:
			if(!Vector2i(X,Y) in wallcells):
				var idx = getAStarCellId(Vector2i(X,Y))
				for neighbourcell in get_surrounding_cells(Vector2i(X,Y)):
					var neighbouridx = getAStarCellId(neighbourcell)
					if(Flight_ASTAR.has_point(neighbouridx)):
						Flight_ASTAR.connect_points(idx,neighbouridx, false)

func getAStarCellId(vCell:Vector2i)->int:
	return int(vCell.y+vCell.x*self.get_used_rect().size.y)

func ViusaliseAstar(_astar : AStar2D):
	for p in _astar.get_point_ids():
		for c in _astar.get_point_connections(p):
			var newpath : Path2D = Path2D.new()
			add_child(newpath)
			newpath.curve = Curve2D.new()
			newpath.curve.add_point(_astar.get_point_position(p))
			newpath.curve.add_point(_astar.get_point_position(c))
	pass

func getAStarPath(_astar : AStar2D,vStartPosition:Vector2,vTargetPosition:Vector2)->PackedVector2Array:
	var vCellStart = local_to_map(vStartPosition)
	var idxStart=getAStarCellId(vCellStart)
	var vCellTarget = local_to_map(vTargetPosition)
	var idxTarget=getAStarCellId(vCellTarget)
	# Just a small check to see if both points are in the grid
	if _astar.has_point(idxStart) and _astar.has_point(idxTarget):
		return Array(_astar.get_point_path(idxStart, idxTarget,true))
	return []

func ConnectDoorsIntraScene(_astar : AStar2D):
	var alldoorsinscene = GetAllDoorsInScene(owner.get_parent().room.Name)
	var allinterscenedoors : Array[Door]
	var allbluedoors : Array[Door]
	var allorangedoors : Array[Door]
	for i : Door in alldoorsinscene:
		if(i.SameSceneDoors == i.DoorPair.TargetScene):
			allinterscenedoors.append(i)
		if(i.SameSceneDoors == i.DoorPair.BluePortal):
			allbluedoors.append(i)
		if(i.SameSceneDoors == i.DoorPair.OrangePortal):
			allorangedoors.append(i)
	for b in allbluedoors:
		for o in allorangedoors:
			if(b.DoorIdentifier == o.DoorIdentifier):
				var Bclosestpointid = _astar.get_closest_position_in_segment(b.global_position)
				var Oclosestpointid = _astar.get_closest_position_in_segment(o.global_position)
				Bclosestpointid = _astar.get_closest_point(Bclosestpointid)
				Oclosestpointid = _astar.get_closest_point(Oclosestpointid)
				#var ptext = PlaceholderTexture2D.new()
				#ptext.size = Vector2(32,32)
				#var newspr : Sprite2D = Sprite2D.new()
				#newspr.texture = ptext
				#add_child(newspr)
				#newspr.global_position = _astar.get_point_position(Bclosestpointid)
				#var newspr2 : Sprite2D = Sprite2D.new()
				#newspr2.texture = ptext
				#add_child(newspr2)
				#newspr2.global_position = _astar.get_point_position(Oclosestpointid)
				
				_astar.add_point(_astar.get_point_count()+1,b.global_position,5)
				var bpointidx = _astar.get_point_count()
				_astar.connect_points(Bclosestpointid,bpointidx,true)
				
				_astar.add_point(_astar.get_point_count()+1,o.global_position,5)
				var opointidx = _astar.get_point_count()
				_astar.connect_points(Oclosestpointid,opointidx,true)
				
				_astar.connect_points(bpointidx,opointidx,true)
	
	for d in allinterscenedoors:
		var dClosedPointID = _astar.get_closest_position_in_segment(d.global_position)
		dClosedPointID = _astar.get_closest_point(dClosedPointID)
		
		_astar.add_point(_astar.get_point_count()+1,d.global_position,5)
		var dpointidx = _astar.get_point_count()
		_astar.connect_points(dClosedPointID,dpointidx,true)
		

func GetAllDoorsInScene(whatSceneName : String):
	var alldoors = get_tree().get_nodes_in_group("Obj_Door")
	var alldoorsinscene : Array[Door]
	for i in alldoors:
		if(i.owner.get_parent().room.Name==whatSceneName):
			alldoorsinscene.append(i)
	return alldoorsinscene
