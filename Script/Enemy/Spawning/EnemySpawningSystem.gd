extends Node

var enemySpawnAmount : int
@export var maxEnemySpawnAmount : int = 20
@export var SpawnTypeAmount : int = 2
# SpawnType = 1 -> Spawn Loosely = Spawn Rải Rác
# SpawnType = 2 -> Spawn in Clumps = Spawn Chụm Lại

@export var mapW : int
@export var mapH : int
@export var minW : int
@export var minH : int
func _ready() -> void:
	SpawnLoop()


func SpawnLoop() -> void:
	while not Global.isWaveBreak:
		
		enemySpawnAmount = min( randi_range(1,2) * ( 1 + Global.CurrentWave / 10 ) , maxEnemySpawnAmount )
		
		var SpawnType = Global.RandomDecision(SpawnTypeAmount)
		var ChosenPos : Vector2
		
		# Clump SpawnType
		if(SpawnType == 2):
			#print("IS CLUMP!")
			ChosenPos = chooseRandomPos()
		else:
			pass
			#print("IS LOOSE!")
			
			
		for enemy in enemySpawnAmount:
			
			if(SpawnType == 1):
				EnemySpawnTable.spawn_Enemy(chooseRandomPos())
			
			if(SpawnType == 2):
				var WModif = randi_range(-150,150)
				var HModif = randi_range(-120,120)
				var SpawnPos = Vector2(ChosenPos.x + WModif, ChosenPos.y + HModif)
				EnemySpawnTable.spawn_Enemy(SpawnPos)
		
		await get_tree().create_timer(randf_range(0.7,1.5)).timeout
		
	
func chooseRandomPos():
	var side = Global.RandomDecision(4)
	
	match side:
		1: # left
			return Vector2(
				randi_range(-mapW, -minW),
				randi_range(-mapH, mapH)
			)
		2: # right
			return Vector2(
				randi_range(minW, mapW),
				randi_range(-mapH, mapH)
			)
		3: # top
			return Vector2(
				randi_range(-mapW, mapW),
				randi_range(-mapH, -minH)
			)
		4: # bottom
			return Vector2(
				randi_range(-mapW, mapW),
				randi_range(minH, mapH)
			)
	
	
	
	
	
	
	
	
	
