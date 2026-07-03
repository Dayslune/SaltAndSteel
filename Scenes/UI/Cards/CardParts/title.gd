extends Panel

@export var default_font_size : int = 16
@export var min_font_size : int = 4
@export var padding : Vector2 = Vector2(8, 6)
@export var shrink_start_width : float = 140

var label : Label

func _ready() -> void:
	label = $Name
	#label.autowrap = false
	#label.clip_text = false

	#if label.has_signal("text_changed"):
	#	label.connect("text_changed", Callable(self, "_update_size"))

	#call_deferred("_update_size")

func _update_size() -> void:
	if not label:
		return

	var text_min_size = label.get_minimum_size()
	var raw_width = text_min_size.x
	var raw_height = text_min_size.y
	var min_scale = float(min_font_size) / default_font_size
	var scale = 1.0

	#if raw_width > shrink_start_width:
	var overflow = raw_width - shrink_start_width
	var shrink_ratio = clamp(overflow / raw_width * 0.5, 0.0, 1.0) * 1.5
	scale = max(min_scale, 1.0 - shrink_ratio)

	label.scale = Vector2(scale, scale)

	var final_width = raw_width * scale + padding.x * 2.0
	var final_height = raw_height * scale + padding.y * 2.0

	size = Vector2(final_width, final_height)
