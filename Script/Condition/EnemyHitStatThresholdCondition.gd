extends Node

var stat_type: String
var comparison_type: String
var comparison_value: String
var actions: Array[Action] = []
var placeholder_api: Node


func _ready() -> void:
	placeholder_api = get_tree().get_first_node_in_group("PlaceholderAPI")

func setup(condition: EnemyHitStatThresholdConditionData) -> void:
	stat_type = condition.statType
	comparison_type = condition.comparisonType
	comparison_value = condition.comparisonValue
	actions = condition.action
	if not _is_supported_comparison(comparison_type):
		push_error("EnemyHitStatThresholdCondition: unsupported comparison type '%s'." % comparison_type)
		return

	if placeholder_api == null or not placeholder_api.has_method("read"):
		push_error("EnemyHitStatThresholdCondition: PlaceholderAPI autoload is unavailable.")
		return

	if not Global.TowerAttackEnemy.is_connected(towerAttackEnemy):
		Global.TowerAttackEnemy.connect(towerAttackEnemy)


func towerAttackEnemy(tower: Node, enemy: Node, _damage: float) -> void:
	if tower == null or not is_instance_valid(tower) or not tower.is_in_group("Tower"):
		return
	if enemy == null or not is_instance_valid(enemy) or not enemy.is_in_group("Enemy"):
		return

	var stat_value: float = placeholder_api.read(stat_type, enemy, tower)
	var compare_value: float = placeholder_api.read(comparison_value, enemy, tower)
	if not is_finite(stat_value) or not is_finite(compare_value):
		return

	if _compare(stat_value, compare_value):
		playActions(enemy, tower)


func _is_supported_comparison(operator: String) -> bool:
	return operator in [">", "<", ">=", "<=", "=="]


func _compare(stat_value: float, compare_value: float) -> bool:
	match comparison_type:
		">":
			return stat_value > compare_value
		"<":
			return stat_value < compare_value
		">=":
			return stat_value >= compare_value
		"<=":
			return stat_value <= compare_value
		"==":
			return stat_value == compare_value
		_:
			return false


func playActions(target: Node, source: Node = null) -> void:
	for action in actions:
		if action == null or not action.has_method("playActionOnTarget"):
			push_error("EnemyHitStatThresholdCondition: configured action is invalid.")
			continue
		action.playActionOnTarget(target, source)
