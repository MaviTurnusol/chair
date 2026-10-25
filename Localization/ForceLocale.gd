extends Button

@export var LocaleCode : String

func _ready() -> void:
	connect("pressed",ForceLocale)

func ForceLocale():
	TranslationServer.set_locale(LocaleCode)
