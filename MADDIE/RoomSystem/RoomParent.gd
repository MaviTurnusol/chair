extends SubViewport
class_name RoomParent

@export var room : Room:
	set(value):
		room = value
		RoomSet()

func RoomSet():
	var NewRoomScene = room.Scene.instantiate()
	add_child(NewRoomScene)

func _ready() -> void:
	size = Vector2i(640,360)
	render_target_update_mode = SubViewport.UPDATE_ALWAYS
	handle_input_locally = false
	snap_2d_transforms_to_pixel = true
	canvas_item_default_texture_repeat = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_ENABLED
