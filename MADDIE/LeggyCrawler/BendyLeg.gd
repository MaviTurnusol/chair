extends Line2D

var LegUnitRef : Legger.LegUnit
var CurveRef : Curve2D
@export var BossRef : WanderingVagrant
@export var LegIndex : int
func _ready() -> void:
	CurveRef = Curve2D.new()
	await get_tree().create_timer(1).timeout
	LegUnitRef = BossRef.triped_legs.GetLegByIndex(LegIndex)
	UpdateCurve()

func UpdateCurve():
	CurveRef.clear_points()
	var straightpoints : Array[Vector2]
	straightpoints.append(LegUnitRef.LegLine.points[0]) 
	straightpoints.append(LegUnitRef.LegLine.points[1]) 
	straightpoints.append(LegUnitRef.LegLine.points[2]) 
	var newpoints : Array[Vector2]
	for i in range(0,10):
		newpoints.append(_quadratic_bezier(straightpoints[0],straightpoints[1],straightpoints[2],float(i)/10.0))
	for p in newpoints:
		CurveRef.add_point(p)

func _process(delta: float) -> void:
	if(LegUnitRef):
		UpdateCurve()
		DrawLines()
func DrawLines():
	points = CurveRef.tessellate()

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r
