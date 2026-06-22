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
@export var duration : float
@export var amplifier : float