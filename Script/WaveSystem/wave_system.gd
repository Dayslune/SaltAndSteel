extends Node

var waveTime : float
var currentWave : int
@export var Map : String = "CorruptedWasteland"
@onready var timer : Timer
@export var waves : Array[WaveEntry]
var SpawningSystem

#var NextWaveButton = preload("res://Scenes/Test/testnextwave button.tscn")
## This is for testing

func start() -> void:
	Global.NextWave.connect(nextWaveStart)
	Global.WaveEnd.connect(waveEnd)
	Global.EnemyRemoved.connect(on_enemy_removed)
	
	timer = $WaveTime
	#waves = WaveLoader.load_waves_from_folder(Map)
	print(waves.size())

	for wave in waves:
		print("Wave durations: ", wave.duration)
		print(wave.powerReward)
		print("wave resource: ", wave)
		
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
	print(Global.CurrentWave)
	#print(currentWaveData.duration)
	#print(typeof(currentWaveData))
	#print(currentWaveData.get_property_list())
	
	if SpawningSystem:
		SpawningSystem.reset_spawning()
		SpawningSystem.spawnHandler(currentWaveSpawnData)

	if currentWaveData != null:
		# Final wave has infinite uptime - no timer
		if Global.CurrentWave < waves.size() - 1:
			timer.wait_time = currentWaveData.duration
			timer.start()
			timer.one_shot = true
		else:
			timer.wait_time = 999999999 #very high number. 
			timer.start()
			timer.one_shot = true
		timecounting()

func timecounting():
	while not Global.isWaveBreak:
		Global.waveTimeElapsed = timer.wait_time - timer.time_left
		await get_tree().create_timer(0.1).timeout

func _on_wave_time_timeout() -> void:
	Global.emit_signal("WaveEnd")
	
func waveEnd():
	timer.stop()

	if SpawningSystem:
		#SpawningSystem.stopSpawning = true
		SpawningSystem.pauseSpawning = true

	if Global.CurrentWave >= waves.size() - 1:
		check_final_wave_victory()
		return
	
	print("Wave " + str(Global.CurrentWave) + " has ended!")

func nextWaveStart():
	print("Next wave is starting!")
	waveHandle()

func on_enemy_removed() -> void:
	print("ENEMY REMOVED!!")
	if get_tree():
		await get_tree().create_timer(randf_range(0.1,0.5)).timeout 
	# ^ this is to prevent the script from not being to check the last enemy when the 2 last enemies die at the same time.
	check_final_wave_victory()

func check_final_wave_victory() -> void:
	if Global.CurrentWave != waves.size() - 1:
		return

	if SpawningSystem == null:
		return

	if not SpawningSystem.allSpawned:
		return

	if get_tree().get_nodes_in_group("enemy").size() != 0:
		return

	victory()

func victory() -> void:
	print("Victory! All final wave enemies have been defeated.")
	Global.emit_signal("Victory")

func defeat():
	timer.stop()
	if SpawningSystem:
		SpawningSystem.stopSpawning = true
