extends Control

@export var strength : float = 0.1
@export var type : int = 1
var originalPosition : Vector2

func _ready() -> void:
	originalPosition = position

func _process(delta) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var center = get_viewport_rect().size / 2
	var offset = (mouse_pos - center) * strength

	if type == 1:
		position = offset
	if type == 2:
		position = originalPosition + offset
