extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Load()
	
	pass

func _input(event: InputEvent) -> void:
	if(event.is_action_released("SAVEGAMEDEBUG")):
		save()

func save():
	var save = PackedScene.new()
	var par = get_parent()
	for c in par.get_children():
		c.set_owner(par)
		for a in c.get_children():
			a.set_owner(par)
	save.pack(par);

	ResourceSaver.save(save, "user://save_game_whole_everything"+".tscn");

func Load():
	var SavedScene : PackedScene = ResourceLoader.load("user://save_game_whole_everything"+".tscn")
	get_tree().change_scene_to_file("user://save_game_whole_everything"+".tscn")
