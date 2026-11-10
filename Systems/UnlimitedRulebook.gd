extends Node

var player : Player
var cam
var the_woke_left = "Blank"
var the_asleep_right = "Blank"
var crossHair #i thought it was spelled crossair mb
var playerWeapon
var currentScene

var livestock = []
var iteratedLivestock = []
var lockedEnemy = null
var lockedEnemyPosition := Vector2(0, 0)

var HoveredInventory : InventoryComponent
var UIGod : Node

signal got_on_the_talking_point
signal hook_ender
signal KeybindChanged

#0: Character Name, 1: Textbox Color
var char_archive = {
	"hatsunemiku": ["Hatsune Miku", "94d0cc"],
	"flowerguyy": ["Flower Guyy", "b58dd6"],
	"nana": ["Nanāhuātzin","FF0000"],
}

var AmmoCounts : Dictionary[AmmoTypes,int]
enum AmmoTypes{
	Small,
	Medium,
	Large,
}
signal BulletDiscard(WhatType:AmmoTypes)
func DiscardBullet(WhatType : AmmoTypes,howmany:int=1):
	for i in range(0,howmany):
		BulletDiscard.emit(WhatType)

enum ItemAttribute{
	Null,
	MeleeWeapon,
	RangedWeapon,
	Ammo,
	Quest,
}

enum MeleeAnimation{
	Null,
	Stab1,
	Thrust1,
	idk,
	KnifeSlash1,
}
var MeleeAnimationDict : Dictionary[MeleeAnimation,String]={
	MeleeAnimation.Null:"idle",
	MeleeAnimation.Stab1:"stab1",
	MeleeAnimation.Thrust1:"thrust1",
	MeleeAnimation.idk:"thrust1",
	MeleeAnimation.KnifeSlash1:"knifeslash1"
}

#####Make this better sometime, these are signals for dialogue events
signal NanaDialogueEndedBossFightStart

var globalitemdictionary : Dictionary[String,String]={ 
	"IceCream": "uid://7a81k12kb5h0", 
	"Yellow": "",} #uid / paths

func GivePlayerItem(whatItemName : String,doDuplicate = true):
	var itemload : InventoryItem = load(globalitemdictionary[whatItemName])
	if(doDuplicate):
		itemload = itemload.duplicate(true)
	player.inventory_component.AddItemToInventory(itemload)

func LockOnEnemy(enemy):
	if !enemy:
		return
	if !is_instance_valid(enemy):
		return
	if !player:
		return
	if !is_instance_valid(player):
		return
	lockedEnemyPosition = enemy.global_position
	
	#if cam:
		#if is_instance_valid(cam):
			#cam.current_target = lockedEnemyPosition
	pass

func UnlockCamera():
	lockedEnemyPosition = Vector2(0, 0)
	if cam:
		if is_instance_valid(cam):
			cam.current_target = Vector2(0, 0)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("focus"):
		if lockedEnemy == null:
			lockedEnemy = FindClosestEnemy(livestock)
			print(FindClosestEnemy(livestock))
			print(lockedEnemy)
		else:
			if livestock.has(lockedEnemy):
				var newstock = livestock.duplicate()
				newstock.erase(lockedEnemy)
				lockedEnemy = FindClosestEnemy(newstock)
	if Input.is_action_just_pressed("drop_focus"):
		lockedEnemy = null
		UnlockCamera()
	
	if lockedEnemy:
		if is_instance_valid(lockedEnemy):
			LockOnEnemy(lockedEnemy)

func FindClosestEnemy(enemyArray):
	if !player:
		return
	if !is_instance_valid(player):
		return
	
	var closest_enemy = null
	for creature in enemyArray:
		if !creature:
			continue
		if !is_instance_valid(creature):
			continue
		
		if closest_enemy == null:
			closest_enemy = creature
			continue
		
		if creature.global_position.distance_to(player.global_position) < closest_enemy.global_position.distance_to(player.global_position):
			closest_enemy = creature
			continue
	
	return closest_enemy
