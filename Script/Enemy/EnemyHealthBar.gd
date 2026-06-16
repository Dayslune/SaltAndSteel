extends Node2D

var currentStat : EnemyStatData

@onready var healthBar : ProgressBar = $HealthBar

func connectStats( enemyStat : EnemyStatData ):
	currentStat = enemyStat

func _process(delta: float) -> void:
	healthBar.max_value = currentStat.maxHP
	healthBar.value = currentStat.currentHP