extends Node

var enemyBase = preload("res://Scenes/Enemy/EnemyBase.tscn")

# Loading Assets
var enemyNormal : EnemyData = preload("res://Resources/Enemies/Normal.tres")
var enemyFast : EnemyData = preload("res://Resources/Enemies/Fast.tres")
var enemySlow : EnemyData = preload("res://Resources/Enemies/Slow.tres")

# 
var enemyList = [
	{"resource" : enemyNormal, "weight" : 30 }
]

func _ready() -> void:
	add_Enemy_to_list(enemyFast , 20)
	add_Enemy_to_list(enemySlow, 20)
	
func add_Enemy_to_list(enemyResource : EnemyData, weight : int):
	
	enemyList.append({
		"resource" : enemyResource,
		"weight" : weight
	})

func raise_Enemy_weight(enemyResource : EnemyData, amount : int):
	
	for entry in enemyList:
		if entry["resource"] == enemyResource:
			entry["weight"] += amount

func spawn_Enemy(spawn_pos : Vector2):
	
	# Randomize Enemy from List
	
	var TotalWeight = 0
	for entry in enemyList:
		TotalWeight += entry["weight"]
	var pick = randf() * TotalWeight
	var current = 0
	for entry in enemyList:
		current += entry["weight"]
		if pick <= current:
			var enemyInst = enemyBase.instantiate()
			#print(entry["resource"])
			enemyInst.EnemyStats = entry["resource"]
			enemyInst.global_position = spawn_pos
			get_tree().current_scene.add_child(enemyInst)

	
func _process(delta: float) -> void:
	pass
