extends Node


# Signals --------------------------------------
signal ChangeInPower()
signal WaveEnd()
signal NextWave()
signal Defeat()
signal Victory()
signal RunEnd()
signal EnemyRemoved()

signal TowerAmountChange()
signal TowerLimitChange()


# Event signals ---------------------------------

signal TowerAttackEnemy( tower : Node, enemy: Node, damage : float )


# POWER

var Power : int
var powerRegenRate : float = 1.0
var PowerRegenTimer : Timer

# WAVE RELATED

var CurrentWave : int
var isWaveBreak : bool #Pls use this mainly in WaveEndHandler
var waveData : Array[WaveEntry]
var waveTimeElapsed : float
	
# PLACEMENT RELATED

var isPlacingTower : bool = false	

#Hands
var cardsDrawnOnShuffle : int
		
func RandomDecision(choices : int):
	var idx = randi_range(1,choices)	
	return idx

#Tools
var toolsList : Array[ToolData] = []

# Natural Regen Stuffs--------------------------

func _ready():
	pass
	#PowerRegenTimer = Timer.new()
	#PowerRegenTimer.wait_time = powerRegenRate
	#PowerRegenTimer.autostart = true
	#PowerRegenTimer.timeout.connect(_on_regen)
	#add_child(PowerRegenTimer)
	
#func _on_regen():
#	if not isWaveBreak:
#		Power += 1
#		ChangeInPower.emit()
	

#Power ----------------------------------------------

func payPower(amount : int): #Check and pay power. If power not enough then false.
	if amount > Power:
		print("Not Enough Power!")
		return false
	else:
		Power -= amount
		ChangeInPower.emit()
		return true
	


