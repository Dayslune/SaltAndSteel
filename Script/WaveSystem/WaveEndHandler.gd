extends Node

var waves : Array[WaveEntry]
@export var Map : String = "CorruptedWasteland"
var checkFirstPrep := false
var waveSystem 

func _ready() -> void:
	Global.WaveEnd.connect(onWaveEnd)

	waveSystem = get_tree().get_first_node_in_group("WaveSystem")

	waves = waveSystem.waves

func onWaveEnd() -> void:
	print("wave break!!!")
	Global.isWaveBreak = true

	if Global.CurrentWave == 0 and not checkFirstPrep:
		return # The first wave won't have card picking and shop

	Global.Power += waves[Global.CurrentWave].powerReward

	var uiManager = get_tree().get_first_node_in_group("UIManager")
	if uiManager == null:
		print("UIManager can't be found!")
		return

	uiManager.show_card_picking_ui()

func nextWave():
	print("next Wave!")
	if Global.CurrentWave == 0 and not checkFirstPrep: #Keep first wave.
		checkFirstPrep = true #check if the first prep has passed. top 10 messy solution
		Global.isWaveBreak = false
		Global.emit_signal("NextWave")
		return
	
	Global.CurrentWave += 1
	Global.isWaveBreak = false
	Global.emit_signal("NextWave")
	#print(Global.CurrentWave)
	
	
