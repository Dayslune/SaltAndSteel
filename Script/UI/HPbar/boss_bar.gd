extends Control

var currentStat : EnemyStatData = EnemyStatData.new()

#@export var title : String = ""

@onready var bossbar : ProgressBar = $Bossbar

var label : Label = Label.new()

func setup( length : float = 0, width : float = 0, title : String = ""):
	size = Vector2( length , width)
	custom_minimum_size = Vector2( length , width)

	label = $Title
	label.text = title
	

func connectStats( enemyStat : EnemyStatData):
	currentStat = enemyStat
	

func _process(delta: float) -> void:
	bossbar.max_value = currentStat.maxHP
	bossbar.value = currentStat.currentHP
