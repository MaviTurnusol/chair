extends Node

@onready var save_slot_list: HBoxContainer = $CanvasLayer/Control/SaveSlotList

func _ready() -> void:
	var index = 0
	for saveslot : SaveSlotUI in save_slot_list.get_children():
		index += 1
		saveslot.Index = index
		saveslot.save_slot_label.text = saveslot.tprompt + str(index)
