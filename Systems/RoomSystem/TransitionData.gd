extends Resource
class_name TransitionData

@export_subgroup("Mask Animation")
## Leave Blank for no animation
@export var MaskAnimationName : String = ""
@export_range(0,100) var AnimationScale : float = 100
@export var WaitUntilSustain : bool = true
@export var tweenMaskOut : bool = false
@export var maskoutDestinationScale : Vector2 = Vector2(2,2)
@export var DoFadeOut : bool = true

@export_category("Fade Colours")
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
@export var ExitTTweenEase : Tween.EaseType

@export_category("Player Animation")
@export var AnimExitDelay : float = 0
@export var PlayerAnimationOnEnter : String = "EnterDoor"
@export var PlayerAnimationOnExit : String = "ExitDoor"
#Secret Variables
var DoSetPosition : bool
