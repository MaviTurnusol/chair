extends Node
@onready var player_inventory_displayer: InventoryHud = $PlayerInventoryDisplayer
@onready var inventorycontrol: Control = $PlayerInventoryDisplayer/Control/Inventory
@onready var anim_player := $PlayerInventoryDisplayer/AnimationPlayer
var ToggleTween : Tween

func ShowInventory():
	if(ToggleTween):
		ToggleTween.kill()
	
	if(TimeTween):
		TimeTween.kill()
	TimeTween = get_tree().create_tween()
	TimeTween.tween_interval(0.75)
	TimeTween.tween_property(Engine,"time_scale",0.15,0.5)
	
	ToggleTween = get_tree().create_tween()
	player_inventory_displayer.visible = true
	IsActive = true
	UnlimitedRulebook.inventory_activated.emit(true)
	anim_player.play("appear")
	#await get_tree().create_timer(0.3).timeout
	ToggleTween.tween_property(inventorycontrol,"scale",Vector2(1.0, 0.0),0.3)
	ToggleTween.tween_property(inventorycontrol,"scale",Vector2.ONE,0.3)
	
	AudioSystem.AddPauseAudioFX()
	
	Cursor.cursor_mode = Cursor.MODES.DEFAULT

var TimeTween : Tween

func HideInventory():
	if(ToggleTween):
		ToggleTween.kill()
	
	if(TimeTween):
		TimeTween.kill()
	TimeTween = get_tree().create_tween()
	TimeTween.tween_property(Engine,"time_scale",1,0.25)
	
	Engine.time_scale = 1
	
	ToggleTween = get_tree().create_tween()
	anim_player.play_backwards("appear")
	ToggleTween.tween_property(inventorycontrol,"scale",Vector2(1.0, 0.0),0.3)
	ToggleTween.tween_property(inventorycontrol,"scale",Vector2(0.0, 0.0),0.3)
	ToggleTween.tween_property(player_inventory_displayer,"visible",false,0)
	IsActive = false
	UnlimitedRulebook.inventory_activated.emit(false)
	
	AudioSystem.TweenOutPauseAudioFX()
	
	Cursor.cursor_mode = Cursor.MODES.ATTACK_DEF

var IsActive : bool

func ToggleInventory():
	if(IsActive):
		HideInventory()
	else:
		ShowInventory()

func _ready() -> void:
	IsActive = player_inventory_displayer.visible
	HideInventory()

func _exit_tree() -> void:
	Engine.time_scale = 1
