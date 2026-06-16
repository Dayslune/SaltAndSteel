extends Label

var waveNode
var timeElapsed : float

func _ready() -> void:
	waveNode = get_tree().get_first_node_in_group("WaveSystem")
	if not waveNode == null:
		timeElapsed = Global.waveTimeElapsed
	text = "Time Elapsed: %.1f" % (timeElapsed)

func _process(delta: float) -> void:
	if not waveNode == null and not Global.isWaveBreak:
		timeElapsed = Global.waveTimeElapsed
		text = "Time Elapsed: %.1f" % (timeElapsed)
	if Global.isWaveBreak:
		text = "Wave Break!"
