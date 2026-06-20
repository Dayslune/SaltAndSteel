extends Node

#rough idea:
#instantiate premade nodes that handle specific type of conditions for each new conditions added to the game.

var enemyHitCondition: PackedScene = preload("res://Scenes/ConditionManager/EnemyHitCondition.tscn")

var testCondition: EnemyHitConditionData = EnemyHitConditionData.new()

func _ready() -> void:
	
	testCondition.hitAmount = 3
	
	var testEffect = StatusEffect.new() 

	testEffect.effect = 0
	testEffect.duration = 1
	testEffect.amplifier = 50

	testCondition.apply = testEffect 
	
	#applyCondition(testCondition)

func applyCondition( condition : ConditionData ):
	
	if condition is EnemyHitConditionData:
		var enemyHitConditionNode = enemyHitCondition.instantiate()
		enemyHitConditionNode.setup(condition)

		print("instantiated enemyhitcondition")

		get_tree().current_scene.add_child(enemyHitConditionNode)