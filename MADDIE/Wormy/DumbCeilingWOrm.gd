extends Node2D

#Hitboxing
@export var Health : int = 5:
	set(value):
		Health = value
		if(Health<=0):
			Die()

#Behaviour
@export var ChaseSpeed : float = 5
@onready var aggro_zone: Area2D = $AggroZone
var AggroTarget : Node2D
var CurrentState : States = States.Preying:
	set(value):
		StateChanged(CurrentState,value)
		CurrentState = value
enum States{
	Preying,
	Dropping,
	#Landing,
	Chasing,
}
#Dropping
@export var TimeToDrop : float = 3
var DropPoint : Vector2 

#Aesthetic
@onready var worm_graphic: Line2D = $WormGraphic
@export var PreyingMagnitude : float = 5
@export var ChasingWriggleSpeed : float = 5
@export var ChasingOscillateMagnitude : float = 5
@export var SegmentLength : float = 5
var wormseed : int
var preypoints : PackedVector2Array
var PreyTween : Tween
var PreyIndex : int = 0

func StateChanged(_OldState : States,NewState : States):
	if(NewState!=States.Preying):
		if(PreyTween!=null):
			PreyTween.kill()
	if(NewState == States.Dropping):
		Drop()
	#if(NewState == States.Landing):
		#worm_graphic.points[0] = to_local(DropPoint) + Vector2.UP*5
		#await get_tree().create_timer(0.5).timeout
		#CurrentState = States.Chasing

func Drop():
	DropPoint = AggroTarget.global_position
	var DropTween : Tween = get_tree().create_tween()
	var NewLineBody : PackedVector2Array
	for i in preypoints.size():
		NewLineBody.append(to_local(DropPoint))
	DropTween.set_ease(Tween.EASE_IN)
	DropTween.tween_property(worm_graphic,"points",NewLineBody,TimeToDrop)
	await DropTween.finished
	CurrentState = States.Chasing

func _ready() -> void:
	aggro_zone.body_entered.connect(BodyEnteredAggroZone)
	wormseed = randi()
	#ChasingWriggleSpeed = ChasingWriggleSpeed + randf_range(-1,1)
	
	worm_graphic.add_point(Vector2(randf_range(-1,1),randf_range(-1,1))*PreyingMagnitude)
	worm_graphic.add_point(Vector2(randf_range(-1,1),randf_range(-1,1))*PreyingMagnitude)
	worm_graphic.add_point(Vector2(randf_range(-1,1),randf_range(-1,1))*PreyingMagnitude)
	worm_graphic.add_point(Vector2(randf_range(-1,1),randf_range(-1,1))*PreyingMagnitude)
	worm_graphic.add_point(Vector2(randf_range(-1,1),randf_range(-1,1))*PreyingMagnitude)
	worm_graphic.add_point(Vector2(randf_range(-1,1),randf_range(-1,1))*PreyingMagnitude)
	worm_graphic.add_point(Vector2(randf_range(-1,1),randf_range(-1,1))*PreyingMagnitude)
	worm_graphic.add_point(Vector2(randf_range(-1,1),randf_range(-1,1))*PreyingMagnitude)
	preypoints = worm_graphic.points
	MovePreyPoints()

func MovePreyPoints():
	if(CurrentState!=States.Preying):
		return
	PreyIndex+=1
	var Target : PackedVector2Array
	if(PreyIndex>=preypoints.size()):
		PreyIndex = 0
	for i in range(0,preypoints.size()-1):
		var targetindex = (preypoints.size()-1-i)+PreyIndex
		if(targetindex>=preypoints.size()):
			var diff = targetindex - preypoints.size()
			targetindex = 0-diff+1
		Target.append(preypoints[targetindex])
	
	PreyTween = get_tree().create_tween()
	PreyTween.set_ease(Tween.EASE_IN_OUT)
	PreyTween.set_trans(Tween.TRANS_CIRC)
	PreyTween.tween_property(worm_graphic,"points",Target,1)
	PreyTween.finished.connect(MovePreyPoints)

var elapsedtime : float = 0
func _process(delta: float) -> void:
	elapsedtime += delta
	if(CurrentState==States.Chasing):
		worm_graphic.points[0] = worm_graphic.points[0].move_toward(to_local(AggroTarget.global_position),delta*ChaseSpeed)
		for i in range(1,worm_graphic.points.size()):
			if(worm_graphic.points[i].distance_to(worm_graphic.points[i-1])>SegmentLength):
				worm_graphic.points[i] = worm_graphic.points[i].move_toward(worm_graphic.points[i-1]+(Vector2.UP*(sin(wormseed+i+elapsedtime*ChasingWriggleSpeed)*ChasingOscillateMagnitude)),delta*ChaseSpeed)


func BodyEnteredAggroZone(body : Node2D):
	if(CurrentState != States.Preying):
		return
	if(body.is_in_group("player")):
		AggroTarget = body
		CurrentState = States.Dropping

func Die():
	queue_free()
