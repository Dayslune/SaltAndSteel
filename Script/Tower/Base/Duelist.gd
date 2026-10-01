extends SingleTargetTower

var lockedTarget : Node2D

func filter():
	enemyInRange = enemyInRange.filter(func(e): return is_instance_valid(e))

func get_target():
	if lockedTarget != null and (not is_instance_valid(lockedTarget) or lockedTarget.is_queued_for_deletion()):
		lockedTarget = null

	if lockedTarget == null:
		filter()
		var closestDistance = INF
		for enemy in enemyInRange:
			if not is_instance_valid(enemy) or enemy.is_queued_for_deletion():
				continue
			#yo i think that im afraid ts nodes gonna get deleted lmfao
			var distance = tower.global_position.distance_squared_to(enemy.global_position)
			if distance < closestDistance:
				lockedTarget = enemy
				closestDistance = distance

	return lockedTarget


func attack_loop():
	while true:
		if Global.isWaveBreak:
			await Global.NextWave
			await get_tree().create_timer(randf_range(0.1, 0.3)).timeout 
			#This is so that at the start of the wave the attack loop will start at slightly 
			#different time so you wouldnt see all towers attacking at the same pace 
			#Its a lazy fix for now gng
			continue
			
		var target = get_target()
			
		if target:
			attack(target)
			
		await get_tree().create_timer(AttackCooldown).timeout

func attack(target):
	
	if target:

		Global.emit_signal("TowerAttackEnemy", tower, target, Damage)
		tower.emit_signal("towerInteractOnTarget", target)
		target.take_Damage(Damage, Penetration)