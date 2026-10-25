extends Node

func _ready() -> void:
	pass # Replace with function body.

func SaveConfigFile():
	# Create new ConfigFile object.
	var config = ConfigFile.new()

	# Store some values.
	config.set_value("Player1", "player_name", "Steve")
	config.set_value("Player1", "best_score", 10)
	config.set_value("Player2", "player_name", "V3geta")
	config.set_value("Player2", "best_score", 9001)

	# Save it to a file (overwrite if already exists).
	config.save("user://scores.cfg")
