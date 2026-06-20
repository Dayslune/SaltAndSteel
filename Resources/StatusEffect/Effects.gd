extends Resource
class_name StatusEffect

enum Effects {
    Slow,
    Crumbled,
    Fragile,
    Freezing,
    Burn
}

@export var effect : Effects
var duration : float
var amplifier : float