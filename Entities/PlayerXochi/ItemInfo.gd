extends Control
class_name ItemInfoShower

@export var invHud : InventoryHud
@onready var name_label: RichTextLabel = $NameLabel
@onready var description_label: RichTextLabel = $DescriptionLabel

func _ready() -> void:
	invHud.newitemhovered.connect(ShowItem)

func ShowItem(whatitem : InventoryItem):
	if(whatitem):
		name_label.text = ProcText(whatitem.ItemName,whatitem)
		description_label.text = ProcText(whatitem.ItemDescription,whatitem)
	else:
		name_label.text = ""
		description_label.text = ""

func ProcText(desc_text : String,whatItem : InventoryItem=null):
	var newtext = desc_text
	if(whatItem):
		newtext = newtext.format({"BulletCount":str(whatItem.AmmoCount)})
		newtext = newtext.format({"ItemName":str(whatItem.ItemName)})
		#print(newtext)
		#print("IDID")
	return newtext
