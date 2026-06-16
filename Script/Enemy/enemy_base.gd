extends CharacterBody2D

@export var EnemyStats : EnemyData = preload("res://Resources/Enemies/Normal.tres")

var DAMAGE_INDICATOR_SCENE = preload("res://Scenes/UI/DamageIndicator.tscn")

var PowerReward : int
var Defense : float
var Speed : float
var CurrentHP : float
var MaxHP : float

var Path 

var currentStats : EnemyStatData = EnemyStatData.new() #use resource to transfer datas to stuffs like HP bar easier and less messy. cuz its a reference type

var defeatedByTower : bool = false

var baseManager 

func _ready() -> void:
	
	MaxHP = EnemyStats.HP
	Defense = EnemyStats.Defense
	Speed = EnemyStats.Speed
	PowerReward = EnemyStats.Reward
	
	CurrentHP = MaxHP
	
	Path = get_parent()
	
	print(currentStats)

	currentStats.currentHP = CurrentHP
	currentStats.maxHP = MaxHP

	baseManager = get_tree().get_first_node_in_group("BaseManager")


	if EnemyStats.Boss:
		showBossBar()

	#Global.WaveEnd.connect(_waveEnd)
	

func _process(delta: float) -> void:
	
	if not Path == null:
		if not Global.isWaveBreak:
			Path.set_progress(Path.get_progress() + Speed * delta)
			if Path.get_progress_ratio() >= 1:
				reachedBase()

	else:
		queue_free()
	
	currentStats.currentHP = CurrentHP
	currentStats.maxHP = MaxHP
	

func take_Damage(amount : float, pen: float):

	var finalDamage = (max(amount - (Defense * (1 - pen/100) ) , amount * 0.05)) 

	CurrentHP -= finalDamage

	print("Current HP: ", CurrentHP)

	#defense is a direct subtraction (arknights?????) 
	#subtraction cant go lower than 5% of the damage
	#pen (penetration) reduce the effectiveness of the enemy's defense



	show_damage_indicator(finalDamage)

	if CurrentHP <= 0:
		defeatedByTower = true
		die()

func _exit_tree() -> void:
	
	if bossBarInst:
		bossBarInst.queue_free()

func die():
	Global.Power += PowerReward


	queue_free()

func reachedBase():

	if baseManager:
		baseManager.takeDamage(CurrentHP)
	else:
		print("cant find base manager")

	queue_free()



func show_damage_indicator(amount: float) -> void:
	print(amount)
	var ind = null
	if DAMAGE_INDICATOR_SCENE:
		ind = DAMAGE_INDICATOR_SCENE.instantiate()
	else:
		print("skibidi no")
		return
	ind.global_position = Vector2(10, -20)
	if ind.has_method("set_damage"):
		ind.set_damage(amount, MaxHP)
	
	ind.z_index = z_index + 1 #make sure its layer is above the enemy

	print(ind)
	add_child(ind)

var showHpBar : bool = false
var hpBar : PackedScene = preload("res://Scenes/Enemy/EnemyHealthBar.tscn")
var hpBarInst 

func _on_hitbox_mouse_entered() -> void:
	_showHpBar()



func _on_hitbox_mouse_exited() -> void:

	showHpBar = false
	hpBarInst.queue_free()

func _showHpBar():
	hpBarInst = hpBar.instantiate()
	hpBarInst.global_position = Vector2(-30,50)
	hpBarInst.z_index = z_index + 1
	add_child(hpBarInst)
	#print(str(CurrentHP) + " " + str(MaxHP))
	hpBarInst.connectStats(currentStats)

var bossBar : PackedScene = preload("res://Scenes/UI/Enemy/BossBar.tscn")
var bossBarInst

@export var bossBarWidth : float = 25
@export var bossBarLength : float = 1000

func showBossBar():
	bossBarInst = bossBar.instantiate()
	if bossBarInst:
		bossBarInst.connectStats(currentStats)
		bossBarInst.setup(bossBarLength, bossBarWidth)
	
	var bossBarManager = get_tree().get_first_node_in_group("BossBarManager")
	if bossBarManager == null:
		print("CANT FIND BOSSBAR MANAGER")
		return 
	
	bossBarManager.container.add_child(bossBarInst)
