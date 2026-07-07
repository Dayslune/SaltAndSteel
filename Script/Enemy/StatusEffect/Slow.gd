extends Node

var enemyNode
@export var effect : StatusEffect 

#var currentSlowPercent : float

func _ready() -> void:
	enemyNode = get_parent()
	
	if enemyNode:
		enemyNode.applyEffect.connect(applyCheck)


func applyCheck( applyingEffect : StatusEffect ): 

	print( "Checking Effect")
	#print("applying Effect: ",applyingEffect.effect,"effect: ", effect.effect)
	if applyingEffect.effect != effect.effect: # check effect, if is the not same effect then stop
		return
	
	slow( applyingEffect )

func slow( effectDetails : StatusEffect):

	print("Applying Slow!")

	var originalSpeed = enemyNode.Speed 
	var changeSpeed = originalSpeed * ( effectDetails.amplifier / 100 )

	enemyNode.Speed -= changeSpeed

	var duration = effectDetails.duration

	while duration > 0:

		if Global.isWaveBreak:

			if get_tree(): # prevent null value
				await get_tree().process_frame
			continue

		if get_tree():
			await get_tree().create_timer(0.1).timeout 
			duration -= 0.1
	
	enemyNode.Speed += changeSpeed
