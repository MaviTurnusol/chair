extends Node

@export var MeleeHoldParent : Node2D
@export var RangedHoldParent : Node2D
@export var PlayerInventoryComponent : InventoryComponent
@export var PlayerStateMachine : StateMachine
@export var MeleeableStates : Array[State]
@export var RangeeableStates : Array[State]

var CurrentMeleeWeapon : InventoryItem
var MeleeWeaponNode : PlayerMelee
var CanMelee : bool

var CurrentRangedWeapon : InventoryItem
var RangedWeaponNode : PlayerGun
var CanRanged : bool

var CurrentMeleeWeaponIndex : int = 0
var CurrentRangedWeaponIndex : int = 0

var TimeSinceMelee : float = 0

func GetAllMeleeWeapons()->Array[InventoryItem]:
	var invgrid : InventoryGrid = PlayerInventoryComponent.OwnInventoryGrid
	var meleeweapons : Array[InventoryItem]
	for i in invgrid.ItemsInInv:
		if(UnlimitedRulebook.ItemAttribute.MeleeWeapon in i.ItemAttributes):
			meleeweapons.append(i)
	return meleeweapons

func GetAllRangedWeapons()->Array[InventoryItem]:
	var invgrid : InventoryGrid = PlayerInventoryComponent.OwnInventoryGrid
	var rangedweapons : Array[InventoryItem]
	for i in invgrid.ItemsInInv:
		if(UnlimitedRulebook.ItemAttribute.RangedWeapon in i.ItemAttributes):
			rangedweapons.append(i)
	return rangedweapons

func _ready() -> void:
	PlayerStateMachine.StateChanged.connect(CheckIfCanAttack)
	PlayerInventoryComponent.ItemAddedToInventory.connect(CheckIfCanAttack)

func CheckIfCanAttack():
	if(PlayerStateMachine.currentState in MeleeableStates):
		if(!MeleeWeaponNode):
			ShowMelee()
		CanMelee = true
	else:
		if(CanMelee):
			HideMelee()
		CanMelee = false
	
	if(PlayerStateMachine.currentState in RangeeableStates):
		if(!RangedWeaponNode):
			ShowRanged()
		CanRanged = true
	else:
		if(CanRanged):
			HideRanged()
		CanRanged = false

func ShowMelee():
	if(GetCurrentMeleeWeapon()):
		MeleeWeaponNode = CurrentMeleeWeapon.AssociatedScene.instantiate()
		MeleeHoldParent.add_child(MeleeWeaponNode)
func HideMelee():
	if(MeleeWeaponNode):
		MeleeWeaponNode.queue_free()
		MeleeWeaponNode = null

func ShowRanged():
	if(GetCurrentRangedWeapon()):
		RangedWeaponNode = CurrentRangedWeapon.AssociatedScene.instantiate()
		RangedHoldParent.add_child(RangedWeaponNode)
func HideRanged():
	if(RangedWeaponNode):
		RangedWeaponNode.queue_free()
		RangedWeaponNode = null

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("attack")):
		if(CanMelee):
			if(GetCurrentMeleeWeapon() && MeleeWeaponNode):
				var success = MeleeWeaponNode.Use()
				if(success):
					PlayerStateMachine.change_state_to("meleeAttack")
		if(CanRanged):
			if(GetCurrentRangedWeapon() && RangedWeaponNode):
				RangedWeaponNode.Use()
	if(event.is_action_pressed("cyclenextweapon")):
		if(CanMelee):
			HideMelee()
			CurrentMeleeWeapon = null
			var maxsize = GetAllMeleeWeapons().size()
			CurrentMeleeWeaponIndex += 1
			if(CurrentMeleeWeaponIndex>maxsize-1):
				CurrentMeleeWeaponIndex = 0
			GetCurrentMeleeWeapon(CurrentMeleeWeaponIndex)
			print(CurrentMeleeWeapon)
			
			ShowMelee()
		if(CanRanged):
			HideRanged()
			CurrentRangedWeapon = null
			var maxsize = GetAllRangedWeapons().size()
			CurrentRangedWeaponIndex+=1
			if(CurrentRangedWeaponIndex>maxsize-1):
				CurrentRangedWeaponIndex = 0
			GetCurrentRangedWeapon(CurrentRangedWeaponIndex)
			ShowRanged()

func GetCurrentMeleeWeapon(index : int = 0):
	if(!CurrentMeleeWeapon):
		if(GetAllMeleeWeapons().size()>0):
			CurrentMeleeWeapon = GetAllMeleeWeapons()[index]
	return CurrentMeleeWeapon
func GetCurrentRangedWeapon(index : int = 0):
	if(!CurrentRangedWeapon):
		if(GetAllRangedWeapons().size()>0):
			CurrentRangedWeapon = GetAllRangedWeapons()[index]
	return CurrentRangedWeapon

func _process(delta: float) -> void:
	TimeSinceMelee+=delta
