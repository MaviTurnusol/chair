extends Node2D
class_name EnemyPreps

var spider_paths: TileMapLayer
func _ready() -> void:
	spider_paths = get_node("SpiderPaths")
	print("DONE")
