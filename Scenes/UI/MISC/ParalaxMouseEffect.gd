extends Control

@export var strength : float = 0.1

func _process(delta) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var center = get_viewport_rect().size / 2
	var offset = (mouse_pos - center) * strength
	position = offset
