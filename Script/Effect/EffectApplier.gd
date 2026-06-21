extends Node





func applyEffect( target : Node , effect : StatusEffect):
	
	if not target and not target.is_in_group("Enemy"):
		print("Enemy node not found")
		return
	
	print("applied effect!")

	target.emit_signal("applyEffect", effect)
	