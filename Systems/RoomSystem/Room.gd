@icon("uid://cycx8ge2kfc28")
extends Resource
class_name Room
@export var Name : String
##Optional. If set to something other than 0, 0 it locks the camera to the position.
@export var RoomCenter := Vector2(0.0, 0.0)

@export_category("Only one needs to be filled")
@export_file_path("*.tscn") var SceneFilePath : String
@export var ScenePackedScene : PackedScene

var Scene : PackedScene

@export_category("Flags")
@export var BringPlayer : bool = true
