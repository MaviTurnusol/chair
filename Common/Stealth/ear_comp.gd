extends Node

@export var father : Node

@export var WhichPassParam : PassParam
enum PassParam{
	OriginRoom,
	PathToOriginRoom, #Array of doors
	PathToOriginPoint, #Array of doors + SoundTarget
}

func HearSound():
	if father:
		if father.has_method("HearSound"):
			father.SpotTarget()
