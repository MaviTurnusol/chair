extends Label

@export var AmmoType : UnlimitedRulebook.AmmoTypes
var invcomp : InventoryComponent
func _ready() -> void:
	invcomp= UnlimitedRulebook.player.inventory_component
	invcomp.ItemAddedToInventory.connect(UpdateDisplay)
	UnlimitedRulebook.BulletDiscard.connect(UpdateDisplay)
	UpdateDisplay(null)
func UpdateDisplay(_nullvar : Variant=null):
	if(!UnlimitedRulebook.AmmoCounts.has(AmmoType)):
		text = str(UnlimitedRulebook.AmmoTypes.find_key(AmmoType)) +":"
		return
	text = str(UnlimitedRulebook.AmmoTypes.find_key(AmmoType))+": " + str(UnlimitedRulebook.AmmoCounts[AmmoType])
	#print("IDSADS")
