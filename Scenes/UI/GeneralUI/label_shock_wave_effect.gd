extends Label


@export var duration : float = 0.3
@export var max_scale : float = 1.5

func _ready():
	# Start the shock wave effect when the label is ready
	visible = false
	#play_shock_wave_effect()


func play_shock_wave_effect():
	# Show the label and start the shock wave effect
	visible = true
	scale = Vector2(1, 1)
	modulate.a = 0.6
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(max_scale, max_scale), duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	var tween2 = create_tween()
	tween2.tween_property(self, "modulate:a", 0.0, duration * 1.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	#tween.connect("finished", self, "_on_shock_wave_effect_finished")