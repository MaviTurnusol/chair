@tool
extends EditorPlugin

const CAMERA_SHAKE_SCRIPT := preload("uid://btre1xiack35")
const SHAKE_PROFILE_SCRIPT := preload("uid://cnnsxsyeb6e03")
const ICON := preload("uid://cc87qcesxckhs")

func _enter_tree() -> void:
	add_custom_type("CameraShake", "Node", CAMERA_SHAKE_SCRIPT, ICON)
	add_custom_type("ShakeProfile", "Resource", SHAKE_PROFILE_SCRIPT, null)

func _exit_tree() -> void:
	remove_custom_type("CameraShake")
	remove_custom_type("ShakeProfile")
