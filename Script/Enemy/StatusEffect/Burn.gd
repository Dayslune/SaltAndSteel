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
	if applyingEffect is not Burn: # check effect, if is the not same effect then stop
		return
	
	burn( applyingEffect )

func burn( effectDetails : StatusEffect):

	print("Applying Burn!")

	var damage = effectDetails.burnDamage
	var tick = effectDetails.burnTick
	var duration = effectDetails.duration 

	if tick == 0 :
		print("stop effect because tick = 0 to prevent inifinite yield")
		return 
	
	while duration > 0:
		if Global.isWaveBreak:
			if get_tree():
				await get_tree().process_frame
				continue
			else:
				break
		
		enemyNode.take_Damage(damage)
		await get_tree().create_timer(tick).timeout
