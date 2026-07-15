extends Node


func applyEffects( target : Node , effects : Effects):
	
	if not target and not target.is_in_group("Enemy"):
		print("Enemy node not found")
		return
	
	print("applied effect!")
	print(effects.effects)
	for statusEffect in effects.effects:
		print("yey")
		target.emit_signal("applyEffect", statusEffect)
	