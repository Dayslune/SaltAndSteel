extends Node

var waveTime : float
var currentWave : int
@export var Map : String = "CorruptedWasteland"
@onready var timer : Timer
var waves : Array[WaveEntry]
var SpawningSystem

#var NextWaveButton = preload("res://Scenes/Test/testnextwave button.tscn")
## This is for testing


func start() -> void:
	Global.NextWave.connect(nextWaveStart)
	Global.WaveEnd.connect(waveEnd)
	
	timer = $WaveTime
	waves = WaveLoader.load_waves_from_folder(Map)
	print(waves.size())
	Global.CurrentWave = 0
	SpawningSystem = get_tree().get_first_node_in_group("EnemySpawnHandler")
	
	if SpawningSystem == null:
		print("Enemy Spawning Handler can't be found!")
		return
	
	# Only start the first wave immediately if we're not in a preparation break.
	if not Global.isWaveBreak:
		waveHandle()
	else:
		print("Wave start deferred due to preparation period")
	
func waveHandle() -> void:
	print("Wave " + str(Global.CurrentWave) + " is starting!")
	var currentWaveData = waves[Global.CurrentWave]
	var currentWaveSpawnData = currentWaveData.entries
	#print(currentWaveData)
	print(currentWaveData.duration)
	#print(typeof(currentWaveData))
	#print(currentWaveData.get_property_list())
	SpawningSystem.spawnHandler(currentWaveSpawnData)

	if not currentWaveData == null:
		timer.wait_time = currentWaveData.duration
		timer.start()
		timer.one_shot = true
		timecounting()

func timecounting():
	while not Global.isWaveBreak:
		Global.waveTimeElapsed = timer.wait_time - timer.time_left
		await get_tree().create_timer(0.1).timeout

	#if Global.isWaveBreak:
	#	timer.wait_time = 0 #end the wave

func _on_wave_time_timeout() -> void:

	Global.emit_signal("WaveEnd")
	
func waveEnd():

	timer.stop()

	if Global.CurrentWave >= waves.size() - 1:
		print("YOU WON!!!!")
		return
	
	print("Wave " + str(Global.CurrentWave) + " has ended!")

func nextWaveStart():
	print("Next wave is starting!")
	waveHandle()
	
	
