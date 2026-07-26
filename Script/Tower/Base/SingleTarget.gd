extends Node
class_name SingleTargetTower

var Damage : float
var AttackCooldown : float
var Prioritize : String #this is useless (for now)
var AttackRange : float
var Penetration : float = 0
var sprite : Sprite2D
@onready var tower : Tower = get_parent()
@onready var hitbox = tower.get_node("Range")
@onready var line = $AttackLine

var currentStat : TowerData

var enemyInRange = []

func setup(data : TowerData):
	
	Damage = data.Damage
	AttackCooldown = data.AttackCooldown
	Penetration = data.Penetration
	currentStat = tower.currentStat
	sprite = tower.get_node("TowerSprite")
	hitbox.area_entered.connect(_on_enemy_entered)
	hitbox.area_exited.connect(_on_enemy_exited)
	print(data)
	setStats()
	attack_loop()



func setStats() -> void:
	Damage = tower.Damage * tower.damageMultiplier + tower.flatDamageBonus
	Damage *= 1 + tower.percentDamageBonus / 100
	AttackCooldown = tower.ASP * tower.ASPMultiplier - tower.flatASPBonus
	AttackCooldown *= 1 - tower.percentASPBonus / 100
	AttackRange = tower.AttackRange * tower.rangeMultiplier + tower.flatRangeMultiplier
	AttackRange *= 1 + tower.percentRangeBonus / 100


	currentStat.Damage = Damage
	currentStat.AttackCooldown = AttackCooldown
	currentStat.AttackRange = AttackRange

	#for attack range
	if hitbox:
		hitbox.get_child(0).shape.radius = AttackRange

	print("Damage: ", Damage, " AttackCooldown: ", AttackCooldown, " AttackRange: ", AttackRange)


func _on_enemy_entered(area):
	var enemy = area.get_parent()
	if enemy.is_in_group("enemy") and not enemyInRange.has(enemy):
		enemyInRange.append(enemy)


func _on_enemy_exited(area):
	var enemy = area.get_parent()
	if enemy.is_in_group("enemy") and enemyInRange.has(enemy):
		enemyInRange.erase(enemy)


func filter():
	enemyInRange = enemyInRange.filter(func(e): return is_instance_valid(e))
	#This is basically just filtering/deleting the enemy that don't exist anymore. 


func get_farthest_enemy():
	filter()
	
	if enemyInRange.is_empty():
		return null
	
	var closest = enemyInRange[0]
	if closest.Path == null:
		return null 
	
	var maxDist = closest.Path.get_progress_ratio()
	
	for enemy in enemyInRange:

		if closest.Path == null:
			continue

		var dist = enemy.Path.get_progress_ratio()
		
		if dist > maxDist:
			closest = enemy 
			maxDist = dist 
			
	return closest

func attack_loop():
	while true:
		if Global.isWaveBreak:
			await Global.NextWave
			await get_tree().create_timer(randf_range(0.0, 0.2)).timeout 
			#This is so that at the start of the wave the attack loop will start at slightly 
			#different time so you wouldnt see all towers attacking at the same pace 
			#Its a lazy fix for now gng
			continue
			
		var target = get_farthest_enemy()
			
		if target:
			attack(target)
			
		await get_tree().create_timer(AttackCooldown).timeout

func attack(target):
	
	if target:

		Global.emit_signal("TowerAttackEnemy", tower, target, Damage)
		tower.emit_signal("towerInteractOnTarget", target)
		target.take_Damage(Damage, Penetration)
		

		line.clear_points()
		line.add_point(tower.global_position)
		line.add_point(target.global_position)
		line.visible = true
		var distimeDiv = randf_range(1,50) 
		await get_tree().create_timer(AttackCooldown/distimeDiv).timeout
		
		line.visible = false
		
		
	
	#print("Attacking: ", target)
	#print(AttackCooldown)
	
	
	
	
	
	
	
	
	
	
