extends Node

@export var currenStats : EnemyStatData = EnemyStatData.new()
# why did i use enemyStatData?
# well, it will def be changed in the future. but currently it works as it only saves 2 values
# which is currentHP and maxHP so it works for everything that has HP bars.

var baseMaxHP : float 
var currentHP : float 

func takeDamage(amount : float):
	var finalDamage = amount # current formula 

	currentHP = currentHP - finalDamage

	currenStats.currentHP = currentHP
	currenStats.maxHP = baseMaxHP

	if currentHP <= 0:
		print("DEFEAT")
		defeat()

func initialize( setMaxHP : float ):
	baseMaxHP = setMaxHP
	currentHP = baseMaxHP

	healthBarSetUp()

	currenStats.currentHP = currentHP
	currenStats.maxHP = baseMaxHP

func defeat():
	pass

var hpBar : PackedScene = preload("res://Scenes/UI/Enemy/BossBar.tscn")
var hpBarInst

@export var hpBarWidth : float = 20.0
@export var hpBarLength : float = 403.0
@export var baseTitle : String = "Base HP"

func healthBarSetUp():
	hpBarInst = hpBar.instantiate()
	hpBarInst.setup(hpBarLength, hpBarWidth, baseTitle)
	hpBarInst.connectStats(currenStats)

	var HUD = get_tree().get_first_node_in_group("HUD")

	if HUD and hpBarInst:
		HUD.showBaseHpBar(hpBarInst)
	else:
		print("Cant find HUD node or hpBarInst")
