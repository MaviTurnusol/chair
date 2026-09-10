extends Area2D
class_name InteractionPrompt

@onready var PromptArea : Area2D = self
@export var InteractRange : float
@export var InteractEvent : String = "Interact"
@onready var prompt_label: RichTextLabel = $Prompt/PromptLabel
@onready var prompt: Node2D = $Prompt
@export var InteractObject : Node

var IsInteractable : bool = false
var _playerInteractor : ActionableFinder

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PromptArea.get_node("CollisionShape2D").shape = CircleShape2D.new()
	PromptArea.get_node("CollisionShape2D").shape.radius = InteractRange
	SetPromptToActionKey()
	prompt.visible = IsInteractable
	if(!prompt.visible):
		prompt.scale = Vector2.ZERO
	PromptArea.area_entered.connect(PromptAreaEntered)
	PromptArea.area_exited.connect(PromptAreaExited)

func PromptAreaEntered(Enterer : Node2D):
	if(Enterer is ActionableFinder):
		if(_playerInteractor==null):
			_playerInteractor = Enterer
		if(_playerInteractor.CanAction):
			var PromptTween : Tween = get_tree().create_tween()
			PromptTween.set_ease(Tween.EASE_OUT)
			PromptTween.set_trans(Tween.TRANS_QUAD)
			PromptTween.tween_property(prompt,"scale", Vector2(1,1),0.15)
			
			prompt.global_rotation = 0
			
			#_playerInteractor.interactables.append(self)
			IsInteractable = true
			
			UpdatePrompt()

func DestroyAndAnimate():
	reparent(get_tree().root)
	await get_tree().process_frame
	
	IsInteractable = false
	PromptArea.get_node("CollisionShape2D").disabled = true
	prompt.global_rotation = 0
	prompt.visible = true
	
	#_playerInteractor.interactables.erase(self)
	var PromptTween : Tween = get_tree().create_tween()
	PromptTween.tween_property(prompt,"scale", Vector2(0,0),0.10)

	await PromptTween.finished
	queue_free()

func PromptAreaExited(Enterer : Node2D):
	if(Enterer is ActionableFinder):
		var PromptTween : Tween = get_tree().create_tween()
		PromptTween.tween_property(prompt,"scale", Vector2(0,0),0.15)
	
		prompt.global_rotation = 0
		
		#_playerInteractor.interactables.erase(self)
		IsInteractable = false
		
		PromptTween.finished.connect(UpdatePrompt)
		#UpdatePrompt()

func UpdatePrompt():
	prompt.visible = IsInteractable


func SetPromptToActionKey():
	var inputmap = InputMap
	var input_events : Array[InputEvent] = inputmap.action_get_events(InteractEvent)
	var keyname : String
	for event in input_events:
		if(event is InputEventKey):
			keyname = OS.get_keycode_string(event.physical_keycode)
			prompt_label.text = keyname

func action():
	if(InteractObject):
		if(InteractObject.has_method("action")):
			InteractObject.action()
			prompt.visible = false
		else:
			assert(false,"No Interact method on interactable object")
	else:
		assert(false,"No Interact Object on interaction prompt")

func _exit_tree() -> void:
	if(_playerInteractor):
		#if(self in _playerInteractor.interactables):
			#_playerInteractor.interactables.erase(self)
		pass
