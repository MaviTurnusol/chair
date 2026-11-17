@tool
extends Node

@export var tile_map_layer: TileMapLayer:
	set(value):
		tile_map_layer.self_modulate = Color.WHITE
		tile_map_layer = value
		tile_map_layer.self_modulate = Color8(Value,Value,Value)
@export var Name : String = "Export"
@export_range(0,255,1,"prefer_slider") var Value : int = 255:
	set(value):
		Value = value
		if(tile_map_layer):
			tile_map_layer.self_modulate = Color8(Value,Value,Value)
const ExportPath = "res://TilemapExporter/ExportDir/"
@export var ExportButton : bool = false:
	set(value):
		CreateImage()
		print("EXPORTED " + Name + " to " + ExportPath)
		value = false

#func _ready() -> void:
	#CreateImage()

func CreateImage():
	if(tile_map_layer == null):
		print("FAILURE: NO TILEMAPLAYER SELECTED")
		return
	tile_map_layer.force_update_transform()
	tile_map_layer.notify_runtime_tile_data_update()
	var tilemapRes : Vector2
	var size : Vector2i = Vector2i.ZERO
	var usedcells = tile_map_layer.get_used_cells()
	var usedrect = tile_map_layer.get_used_rect()
	var min = usedrect.position
	var max = usedrect.size
	
	size = max
	
	var offsetX = min.x
	var offsetY = min.y
	
	size.x = abs(size.x)
	size.y = abs(size.y)
	
	var tilesize = tile_map_layer.tile_set.tile_size
	size *= tilesize
	
	var offsetused : Array[Vector2i]
	for i in usedcells:
		offsetused.append(i-Vector2i(offsetX,offsetY))
	
	tilemapRes = Vector2(size.x,size.y)
	
	var NewImage : Image = Image.new()
	var data : PackedByteArray
	for Y in range(0,size.y):
		for X in range(0,size.x):
			var vecrounded = Vector2i(round(X/tilesize.x),round(Y/tilesize.y))
			#print(vecrounded)
			if(vecrounded in offsetused):
				#print("USED")
				data.append(Value)
			else:
				data.append(0)
			

	NewImage = NewImage.create_from_data(tilemapRes.x,tilemapRes.y,false,Image.FORMAT_L8,data)
	var imagedata = NewImage.save_png_to_buffer()
	var dir = FileAccess.open(ExportPath+Name+".png",FileAccess.WRITE)
	dir.store_buffer(imagedata)
	EditorInterface.get_resource_filesystem().scan()
	#dir.(NewImage,true)
	print("COMPLETE")
	#print(dir.get_current_dir())
	#dir.
	#print(error_string(err))
