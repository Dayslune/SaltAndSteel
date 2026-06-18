extends Label

var TowerManager

func _ready() -> void:
	TowerManager = get_tree().get_first_node_in_group("TowerManager")

	Global.TowerAmountChange.connect(towerAmountChange)
	Global.TowerLimitChange.connect(towerLimitChange)

var towerAmount : int 
var towerLimit : int

func towerAmountChange():
	towerAmount = TowerManager.currentTowerAmount
	changeText()

func towerLimitChange():
	towerLimit = TowerManager.currentTowerLimit
	changeText()

func changeText():
	if text:
		text = "Tower Limit: " + str(towerAmount) + "/" + str(towerLimit)