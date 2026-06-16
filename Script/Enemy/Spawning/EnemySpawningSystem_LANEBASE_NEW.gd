extends Node

@export var enemyBase : PackedScene = preload("res://Scenes/Enemy/EnemyBase.tscn")
var enemyPath : PackedScene

func start(map : String) -> void:
	var enemyPathString = "res://Scenes/Maps/Paths/" + map + "Path.tscn"
	enemyPath = load(enemyPathString)
	
var stopSpawning : bool = false
var pauseSpawning : bool = false

func spawnHandler(entries : Array[SpawnEntry]):
	var idx = 0
	entries.sort_custom(func(a,b): return a.spawnTimeline < b.spawnTimeline)
	
	while idx < entries.size():
		var entry = entries[idx]
		
		if stopSpawning:
			break


		if pauseSpawning:
			continue 
		

		if Global.waveTimeElapsed >= entry.spawnTimeline:
			spawnMiniWave(entry)
			idx += 1
		
		await get_tree().process_frame


func spawnMiniWave(enemies: SpawnEntry):
	for count in enemies.amount:
			var enemy = enemyBase.instantiate()
			enemy.EnemyStats = enemies.Enemy

			if stopSpawning:
				continue

			if pauseSpawning:
				continue 
			await get_tree().create_timer(enemies.delay).timeout
			spawnEnemy(enemy)

func spawnEnemy(enemy : Node):
	var enemyPathInst = enemyPath.instantiate()
	get_tree().get_first_node_in_group("Map").add_child(enemyPathInst)
	enemyPathInst.get_node("PathFollow2D").add_child(enemy)
