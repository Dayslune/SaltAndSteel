extends Node2D

@export var delayFrame : int
var pen : float = 0

func _ready():
	visible = false

func explode(radius : float, damage : float, _vfx : PackedScene, _lifespan : float):
	
	visible = true

	var explosion 
	var splashArea #The Area2D
	var splashRange #The circle range


	if _vfx == null:
		explosion = $DefaultExplosion
		playVFX()
	else:
		pass #no curent special vfx or anything 
	
	splashArea = $SplashArea
	splashRange = $SplashArea/AreaRange

	scale = Vector2(radius, radius)

	for i in range(delayFrame):
		await get_tree().process_frame

	for area in splashArea.get_overlapping_areas():
		areaEnteredSplash(area, damage)

	if _lifespan > 0:
		await get_tree().create_timer(_lifespan).timeout
		explosion.queue_free()
	else:
		explosion.queue_free()

func areaEnteredSplash(area, damage):
	#print("splash hit: ", area) 
	var enemy = area.get_parent()
	if enemy.is_in_group("enemy"):
		#print(damage)
		enemy.take_Damage(damage, pen)


func playVFX():
	

	var currentExplosionRadius = $SplashArea/AreaRange.shape.radius

	var particle = $Smoke#.duplicate() as GPUParticles2D

	#particle.scale = Vector2(0.4,0.4)

	

	var particleMaterial = particle.process_material#.duplicate() as ParticleProcessMaterial

	particleMaterial.scale_min = currentExplosionRadius * 0.75
	particleMaterial.scale_max = currentExplosionRadius * 0.85
	
	particle.emitting = true

	#very messy rn, but works.
	#there are magic numbers but this is a visual effect gng.
	#tbh a particle vfx isnt needed but i have experience making particle before so i wanna try ts here