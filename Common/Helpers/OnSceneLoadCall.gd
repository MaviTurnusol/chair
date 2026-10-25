extends Node

@export var ObjectToCall : Node
@export var FunctionName : String

func _ready() -> void:
	SceneManager.switchscene.connect(OnSwitchScene)
	OnSwitchScene("blank")

func OnSwitchScene(scene : String="blank"):
	await get_tree().process_frame
	if(owner.get_parent()==UnlimitedRulebook.currentScene):
		ObjectToCall.call(FunctionName)
