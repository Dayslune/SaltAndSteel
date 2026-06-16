extends ToolData
class_name TowerStatModifier

#-------- Info --------
# This is the data for tools that modify tower stats.
# When creating new variables, pls make the name end with "_modi"
# This is because the tool description script detects variables that end with "_modi"
# I cant rlly think of a better way to do this without changing a lot of stuffs(🥀)


# ⚠️⚠️⚠️⚠️⚠️⚠️⚠️⚠️
# if you change the name of the variable pls go to ToolDesc and changes the display
# map and also go to the TowerBase to change. (if you use VSCode its easier tho 
# just use F2 when renaming)


enum TowerType {
    SingleTarget,
    AreaOfEffect,
}
@export_group("Modifier")

@export_group("Tower Type")
@export var towerType : TowerType


@export_group("General Stat Modifiers")
@export var damageMultiplier_modi : float = 1.0
@export var rangeMultiplier_modi : float = 1.0
@export var aspMultiplier_modi : float = 1.0

@export var damagePercentageModifier_modi : float = 0.0 # use for stuffs like +20% damage
@export var rangePercentageModifier_modi : float = 0.0
@export var aspPercentageModifier_modi : float = 0.0

@export var damageFlatModifier_modi : float = 0.0
@export var rangeFlatModifier_modi : float = 0.0
@export var aspFlatModifier_modi : float = 0.0

# For AOE towers

@export_group("AOE Tower Modifiers")
@export var AOERadiusMultiplier_modi : float = 1.0
@export var AOERadiusFlatModifier_modi : float = 0.0
@export var AOERadiusPercentageModifier_modi : float = 0.0
