extends Action 
class_name ApplyStatusEffect

@export var effects: Effects

func playActionOnTarget(target: Node, source: Node = null):
	apply(target, effects, source)

func apply(target: Node, effects: Effects, source: Node):

	if target == null or not target.is_in_group("Enemy"):
		print("Enemy node not found")
		return
	
	print("applied effect!")
	print(effects.effects)
	for statusEffect in effects.effects:
		print("yey")
		target.emit_signal("applyEffect", statusEffect)


