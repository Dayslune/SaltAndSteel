extends Control

@onready var credits = $Credits

func _ready() -> void:
	credits.visible = false

func creditsFunc() -> void:
	credits.visible = not credits.visible