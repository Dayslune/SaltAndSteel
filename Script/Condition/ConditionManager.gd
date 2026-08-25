extends Node

#rough idea:
#instantiate premade nodes that handle specific type of conditions for each new conditions added to the game.

var enemyHitCondition: PackedScene = preload("res://Scenes/ConditionManager/EnemyHitCondition.tscn")

var testResource:= preload("res://Resources/Tools/ApplyEffectWithCondition/SaintNoelServant.tres")

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

	if condition is EnemyHitConditionData:
		conditionNode = enemyHitCondition.instantiate()

	get_tree().current_scene.add_child.call_deferred(conditionNode)

	conditionNode.setup(condition)
