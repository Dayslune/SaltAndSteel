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
	
	if condition is EnemyHitConditionData:
		var enemyHitConditionNode = enemyHitCondition.instantiate()

		print("instantiated enemyhitcondition")

		get_tree().current_scene.add_child.call_deferred(enemyHitConditionNode)

		enemyHitConditionNode.setup(condition)

# TO-DO: the current system has some troubles dealing with multiple conditions.
# 
