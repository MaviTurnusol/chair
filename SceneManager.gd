extends Node

var RoomDict : Dictionary[String,Room]
func _ready() -> void:
	var Rooms = dir_contents("res://RoomsAndLevels/")
	for r : Room in Rooms:
		if(r.SceneFilePath):
			r.Scene = load(r.SceneFilePath)
		elif(r.ScenePackedScene):
			r.Scene = r.ScenePackedScene
		else:
			assert(false,"ROOM RESOURCE ERROR at ROOM: " + r.Name)
		RoomDict[r.Name] = r

#CODE SNIPPET FROM ONLINE TO GET CONTENTS OF DIRECTORY
func dir_contents(path):
	var res_loads = []

	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.get_extension() == "tres":
					var full_path = path.path_join(file_name)
					res_loads.append(load(full_path))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

	return res_loads
