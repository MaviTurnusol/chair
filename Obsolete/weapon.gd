extends Node2D

class_name Weapon

var realAnima
@export var playerAnima : AnimatedSprite2D
@export var anima : AnimatedSprite2D

enum STATES {NO_ANIM, FOLLOW_PLAYER, UNIQUE_ANIM}
var state = STATES.FOLLOW_PLAYER
#there are two sprites on top of each other
#when player doesn't have an animation the weapon makes the player invisible
#and draws the player itself on the playerAnima node

var weaponOwner

@export var initialAnim : String

func _ready():
	weaponOwner = get_parent().get_parent()
	if weaponOwner.has_node("anima"):
		realAnima = weaponOwner.get_node("anima")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	sync_animations()
	sync_hitboxes()
	pass


func sync_hitboxes():
	if !weaponOwner:
		return
	if !is_instance_valid(weaponOwner):
		return
	
	for child in get_children():
		if child is Area2D:
			if child.name == anima.animation && child.tiedFrames.has(anima.frame):
				child.set_deferred("monitorable", true)
				child.set_deferred("monitoring", true)
				child.modulate = Color.RED
			else:
				child.set_deferred("monitorable", false)
				child.set_deferred("monitoring", false)
				child.modulate = Color.WHITE

func sync_animations():
	if !weaponOwner:
		return
	if !is_instance_valid(weaponOwner):
		return
	
	if !(weaponOwner.has_node("anima")):
		return
	
	if anima.animation != "blank" && !realAnima.sprite_frames.has_animation(anima.animation):
		state = STATES.UNIQUE_ANIM
	
	if state == STATES.UNIQUE_ANIM:
		
		if anima.animation == "blank":
			realAnima.visible = true
			state = STATES.NO_ANIM
			return
		
		realAnima.stop()
		realAnima.visible = false
		anima.visible = true
		playerAnima.visible = true
		
		playerAnima.play(anima.animation)
		playerAnima.pause()
		playerAnima.frame = anima.frame
		
	
	if state == STATES.FOLLOW_PLAYER:
		
		if !anima.sprite_frames.has_animation(realAnima.animation):
			state = STATES.NO_ANIM
			return
		
		anima.visible = true
		playerAnima.visible = false
		
		anima.play(realAnima.animation)
		anima.pause()
		anima.frame = realAnima.frame
		
	if state == STATES.NO_ANIM:
		
		if anima.sprite_frames.has_animation(realAnima.animation):
			state = STATES.FOLLOW_PLAYER
			return
			
		anima.visible = false
		playerAnima.visible = false
		anima.stop()
		playerAnima.stop()
