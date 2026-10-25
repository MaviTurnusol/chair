class_name HelperGizmo extends Marker2D

@export var Pos : Vector2
var Marker : Marker2D
var GizmoName : String

func _ready() -> void:
	if(!Engine.is_editor_hint()):
		queue_free()

func _init(Name:String="Null") -> void:
	Marker = Marker2D.new()
	add_child(Marker)
	GizmoName = Name

func _enter_tree() -> void:
	owner = get_tree().edited_scene_root
	name = GizmoName

func _process(delta: float) -> void:
	if(global_position!=Pos):
		global_position = Pos
