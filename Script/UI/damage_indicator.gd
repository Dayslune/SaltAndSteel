extends Node2D

@export var rise_distance := 40.0
@export var base_duration := 0.6
@export var max_extra_duration := 1.2
@export var base_scale := 1.0
@export var max_scale := 1.6

@export var startingColor : Color
@export var endingColor : Color

func _ready() -> void:
	pass

func set_damage(amount: float, max_hp: float) -> void:
	var label: Label = $Label2D
	label.text = str(int(amount))
	var ratio := 0.0
	if max_hp > 0:
		ratio = clamp(amount / max_hp, 0.0, 1.0)

	var duration : float = lerp(base_duration, base_duration + max_extra_duration, ratio)
	var scale_factor : float = lerp(base_scale, max_scale, ratio)
	var targetColor := startingColor.lerp(endingColor, ratio)

	label.modulate = targetColor
	label.scale = Vector2(scale_factor, scale_factor)

	var end_color := Color(targetColor.r, targetColor.g, targetColor.b, 0.0)
	var end_pos := position + Vector2(0, -rise_distance)

	var tween := create_tween()
	tween.tween_property(self, "position", end_pos, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate", end_color, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_callback(Callable(self, "queue_free"))
