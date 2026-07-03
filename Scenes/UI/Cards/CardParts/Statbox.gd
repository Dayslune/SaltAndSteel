extends Panel

@export var icon : Texture2D
@export var statInfo : String

func _ready() -> void:
	setup(icon, statInfo)


func setup( _icon : Texture2D, _statInfo : String) -> void:
	
	icon = _icon
	statInfo = _statInfo

	var textureRect = $HBoxContainer/MarginContainer/TextureRect
	var label = $HBoxContainer/Label

	textureRect.texture = icon
	label.text = statInfo

	custom_minimum_size.x = (label.get_minimum_size().x + textureRect.get_minimum_size().x)/2 + 40 

	# ^ extend the panel to fit the texts
