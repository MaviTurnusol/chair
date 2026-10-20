extends Resource
class_name TransitionData

@export_category("Mask Animation")
@export var MaskColour : Color = Color.BLACK
@export var TransparentMaskColour : Color = Color(0,0,0,0)

@export_category("Entry")
@export var Delay : float = 0
@export var EntryTime : float = 1
@export var EntryTweenTransition : Tween.TransitionType
@export var EntryTweenEase : Tween.EaseType
@export_category("Sustain")
@export var SustainTime : float = 0
@export_category("Exit")
@export var ExitTime : float = 1
@export var ExitTweenTransition : Tween.TransitionType
@export var ExitTEntryTweenEase : Tween.EaseType

@export_category("Player Animation")
@export var PlayerAnimationOnEnter : String = "EnterDoor"
@export var PlayerAnimationOnExit : String = "ExitDoor"
#Secret Variables
var DoSetPosition : bool
