extends Control
class_name ItemInfoShower

@export var invHud : InventoryHud
@onready var name_label: RichTextLabel = $NameLabel
@onready var description_label: RichTextLabel = $DescriptionLabel

func _ready() -> void:
	invHud.newitemhovered.connect(ShowItem)

func ShowItem(whatitem : InventoryItem):
	if(whatitem):
		name_label.text = whatitem.ItemName
		description_label.text = whatitem.ItemDescription
	else:
		name_label.text = ""
		description_label.text = ""
