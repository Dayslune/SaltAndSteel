extends Node

var requiredHitCount : int 
var applyEffect : StatusEffect
var applyToTowerType : String = ""

var enemyData : Dictionary[String, int] 
#use hashmap aka dictionary to store the enemy hit counts
#TO DO: remove the enemy from the dictionary if the enemy exit tree (aka die)

var effectApplier 

func _ready() -> void:
	effectApplier = get_tree().get_first_node_in_group("EffectApplyHandler")

func setup( condition : EnemyHitConditionData ) -> void:
	
	requiredHitCount = condition.hitAmount
	applyEffect = condition.apply
	applyToTowerType = condition.hitByTowerType

	print("condition set up!")

	Global.TowerAttackEnemy.connect(towerAttackEnemy) 


func towerAttackEnemy( tower : Node, enemy : Node, damage : float):
	
	print("towerAttacking!!")

	if not tower or not tower.is_in_group("Tower"):
		print("not tower")
		return 
	
	if not enemy or not enemy.is_in_group("Enemy"):
		print("not enemy")
		return 
	
	if tower.Type != applyToTowerType and applyToTowerType != "":

		print("different tower TYPE!")

		return 

	print("condition receive successful")

	var enemyId = str(enemy.get_instance_id())

	if enemyData.has(enemyId):
		enemyData[enemyId] += 1
	else:
		enemyData[enemyId] = 1
	

	if enemyData[enemyId] == requiredHitCount:
		#print(enemyData, " apply Effect!!!!!!!!!!!!!")

		enemyData.erase(enemyId)

		if effectApplier:
			effectApplier.applyEffect(enemy, applyEffect)
