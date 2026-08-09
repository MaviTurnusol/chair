extends Node

var player : Player
var cam
var the_woke_left = "Blank"
var the_asleep_right = "Blank"
var crossHair #Im so dumb i thought it was spelled crossair
var playerWeapon
var currentScene

signal got_on_the_talking_point

#0: Character Name, 1: Textbox Color
var char_archive = {
	"hatsunemiku": ["Hatsune Miku", "94d0cc"],
	"flowerguyy": ["Flower Guyy", "b58dd6"]
}
