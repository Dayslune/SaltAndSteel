extends Node

var activeModifier : Dictionary = {}

func tower_type_to_string(tower_type) -> String:
	match tower_type:
		TowerStatModifier.TowerType.SingleTarget:
			return "SingleTarget"
		TowerStatModifier.TowerType.AreaOfEffect:
			return "AreaOfEffect"
		_:
			return str(tower_type)

func addModifier(modifierData : TowerStatModifier):
	var type_name = tower_type_to_string(modifierData.towerType)
	if not activeModifier.has(type_name):
		activeModifier[type_name] = []

	activeModifier[type_name].append(modifierData)
	applyToExistingTower(type_name, modifierData)
	applyTowerLimitModifier(modifierData)

func applyTowerLimitModifier(modifierData : TowerStatModifier) -> void:
	if modifierData.towerLimitMultiplier_modi == 1.0 and modifierData.towerLimitFlatModifier_modi == 0 and modifierData.towerLimitPercentageModifier_modi == 0.0:
		return

	var towerManager = get_tree().get_first_node_in_group("TowerManager")
	if towerManager == null:
		return

	var currentLimit = towerManager.currentTowerLimit
	var newLimit = currentLimit * modifierData.towerLimitMultiplier_modi
	newLimit += modifierData.towerLimitFlatModifier_modi
	newLimit *= 1.0 + modifierData.towerLimitPercentageModifier_modi / 100.0
	var finalLimit = max(int(round(newLimit)), 0)
	var delta = finalLimit - currentLimit
	if delta != 0:
		towerManager.changeCurrentTowerLimit(delta)

func applyToExistingTower(towerType, modifier : TowerStatModifier):
	if towerType is int:
		towerType = tower_type_to_string(towerType)
	if not activeModifier.has(towerType):
		return

	var towers = get_tree().get_nodes_in_group("Tower")
	for tower in towers:

		if tower.Type == towerType:
			tower.applyModifier(modifier)

func applyToNewTower(towerType, towerNode):
	if towerType is int:
		towerType = tower_type_to_string(towerType)
	if activeModifier.has(towerType):
		var modifiers = activeModifier[towerType]
		for modifier in modifiers:
			towerNode.applyModifier(modifier)
