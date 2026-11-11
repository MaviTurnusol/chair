extends Area2D
class_name ActionableFinder

@export var cutscene_state : State
@export var ActionListControl : Control
@export var ActionListEntry : PackedScene
@export var SelectArrow : Control
@export var ArrowOffset : Vector2
var actionlist : Array
var selectidx : int = 0

var IsSelectingFromPrompts : bool = false

var CanAction : bool = true
func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed(&"interact"):
		get_tree().root.get_viewport().set_input_as_handled()
		if(!IsSelectingFromPrompts):
			selectidx = 0
		var actionables = get_overlapping_areas()
		print(actionables)
		if actionables.size() > 0:
			if(actionables.size()==1||IsSelectingFromPrompts):
				#IsSelectingFromPrompts = false
				HideAllOptions()
				#print("UWUWUUWU")
				actionables[selectidx].action()
				
				if cutscene_state:
					cutscene_state.actionable = actionables[selectidx]
			else:
				ShowAllOptions(actionables)
				for i in actionables:
					i.area_exited.connect(exitedAnInteractionPrompter)

func ShowAllOptions(ActionableList : Array[Area2D]):
	actionlist.clear()
	for i in ActionableList:
		var newnode = ActionListEntry.instantiate() 
		ActionListControl.add_child(newnode)
		newnode.get_node("PromptText").text = i.Prompt_Text
		actionlist.append(newnode)
		#print("SHOWN")
	SelectArrow.visible = true
	SelectArrow.global_position = actionlist[selectidx].global_position + ArrowOffset
	IsSelectingFromPrompts = true

func exitedAnInteractionPrompter(body : Node2D):
	if(body is ActionableFinder):
		HideAllOptions()

func HideAllOptions():
	for i in actionlist:
		i.queue_free()
	actionlist.clear()
	SelectArrow.visible = false
	IsSelectingFromPrompts = false


func _input(event: InputEvent) -> void:
	if(!IsSelectingFromPrompts):
		return
	if(event.is_action_pressed("up")):
		selectidx -= 1
		selectidx = clampi(selectidx,0,actionlist.size()-1)
		SelectArrow.global_position = actionlist[selectidx].global_position + ArrowOffset
	if(event.is_action_pressed("down")):
		selectidx +=1
		selectidx = clampi(selectidx,0,actionlist.size()-1)
		SelectArrow.global_position = actionlist[selectidx].global_position + ArrowOffset
	#print(selectidx)

func _ready() -> void:
	SelectArrow.visible = false
