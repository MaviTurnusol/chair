extends Resource
class_name Room
@export var Name : String
@export_category("Only one needs to be filled")
@export_file_path("*.tscn") var SceneFilePath : String
@export var ScenePackedScene : PackedScene

var Scene : PackedScene

@export_category("Flags")
@export var BringPlayer : bool = true
