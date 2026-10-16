extends ConditionData
class_name EnemyHitStatThresholdConditionData

@export var statType : String
@export_enum(">", "<", ">=", "<=", "==") var comparisonType: String = ">"
@export var comparisonValue : String
@export var action: Array[Action]