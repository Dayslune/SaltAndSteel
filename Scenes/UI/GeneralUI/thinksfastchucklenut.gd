extends Panel


@export var animDur : float = 0.3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	visible = false


func playFLASHBLANGanim():

	visible = true
	modulate.a = 1

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, animDur).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)