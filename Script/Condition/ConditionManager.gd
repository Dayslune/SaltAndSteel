extends Node

#rough idea:
#instantiate premade nodes that handle specific type of conditions for each new conditions added to the game.

var enemyHitCondition: PackedScene = preload("res://Scenes/ConditionManager/EnemyHitCondition.tscn")
var enemyHitStatThresholdCondition: PackedScene = preload("res://Scenes/ConditionManager/EnemyHitStatThresholdCondition.tscn")

var testResource:= preload("res://Resources/Tools/ApplyEffectWithCondition/coolidk.tres")

func initialize() -> void:
	
	var testCondition = testResource.condition

	
	var testEffect = testCondition.action

	testCondition.action = testEffect 
	
	#applyCondition(testCondition)
	#applyCondition(testCondition)
	#applyCondition(testCondition)
	#applyCondition(testCondition)
	#applyCondition(testCondition)

func applyCondition( condition : ConditionData ):
	var conditionNode

	if condition is EnemyHitStatThresholdConditionData:
		conditionNode = enemyHitStatThresholdCondition.instantiate()
	elif condition is EnemyHitConditionData:
		conditionNode = enemyHitCondition.instantiate()
	else:
		push_error("ConditionManager: unsupported condition data type '%s'." % condition.get_class())
		return

	get_tree().current_scene.add_child.call_deferred(conditionNode)

	conditionNode.call_deferred("setup", condition)
