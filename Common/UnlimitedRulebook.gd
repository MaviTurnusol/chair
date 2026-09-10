extends Node

var player : Player
var cam
var the_woke_left = "Blank"
var the_asleep_right = "Blank"
var crossHair #Im so dumb i thought it was spelled crossair
var playerWeapon
var currentScene

var HoveredInventory : InventoryComponent

signal got_on_the_talking_point

#0: Character Name, 1: Textbox Color
var char_archive = {
	"hatsunemiku": ["Hatsune Miku", "94d0cc"],
	"flowerguyy": ["Flower Guyy", "b58dd6"],
	"nana": ["Nanāhuātzin","FF0000"],
}

#####Make this better sometime, these are signals for dialogue events
signal NanaDialogueEndedBossFightStart

var globalitemdictionary : Dictionary[String,String]={ 
	"IceCream": "uid://7a81k12kb5h0", 
	"Yellow": "",} #uid / paths

func GivePlayerItem(whatItemName : String):
	var itemload : InventoryItem = load(globalitemdictionary[whatItemName])
	player.inventory_component.AddItemToInventory(itemload)
