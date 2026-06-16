extends Button

func _ready():
	Global.NextWave.connect(WaveBreakEnd)


func _on_pressed() -> void:
	print("why am i here gang")
	Global.emit_signal("NextWave")

func WaveBreakEnd() -> void:
	queue_free()
