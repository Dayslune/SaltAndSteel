extends Node



var currentTowerAmount : int 
var currentTowerLimit : int 

func initialize( defaultTowerLimit : int ):

	currentTowerLimit = defaultTowerLimit
	Global.emit_signal("TowerAmountChange")
	Global.emit_signal("TowerLimitChange")

func changeCurrentTowerAmount( amount : int ):

	currentTowerAmount += amount

	Global.emit_signal("TowerAmountChange")

func changeCurrentTowerLimit( amount : int ):
	currentTowerLimit += amount 

	Global.emit_signal("TowerLimitChange")