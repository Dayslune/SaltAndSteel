extends Control

var Desc
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize()

func initialize():
	Desc = $Panel/Margin/Stats


func setDesc_TowerStatModifier(toolData : TowerStatModifier):
	initialize()
	Desc.text = "Name: " + str(toolData.toolName) + "\n"

	# spaghetti code jumpscare
	# The idea is to check the name of the variable to determine how to display it in the description.
	# the desc is not rlly important so i dont need to overengineer stuffs
	# FOR THE LOVE OF GOD DONT CHANGE THE VARIABLE NAMES PLEASE
	# so its fine, ig
	const MODIFIER_DISPLAY_MAP = {
    "damageMultiplier_modi": {"prefix": "x ", "suffix": " dmg", "default": 1.0},
    "damagePercentageModifier_modi": {"prefix": "+ ", "suffix": "% dmg", "default": 0.0},
    "damageFlatModifier_modi": {"prefix": "+ ", "suffix": " dmg", "default": 0.0},
    "rangeMultiplier_modi": {"prefix": "x ", "suffix": " rng", "default": 1.0},
    "rangePercentageModifier_modi": {"prefix": "+ ", "suffix": "% rng", "default": 0.0},
    "rangeFlatModifier_modi": {"prefix": "+ ", "suffix": " rng", "default": 0.0},
    "aspMultiplier_modi": {"prefix": "x ", "suffix": " asp", "default": 1.0},
    "aspPercentageModifier_modi": {"prefix": "+ ", "suffix": "% asp", "default": 0.0},
    "aspFlatModifier_modi": {"prefix": "+ ", "suffix": " asp", "default": 0.0},
    "AOERadiusMultiplier_modi": {"prefix": "x ", "suffix": " AOE radius", "default": 1.0},
    "AOERadiusFlatModifier_modi": {"prefix": "+ ", "suffix": " AOE radius", "default": 0.0},
	}

	for stat in toolData.get_property_list():
		if stat.usage & PROPERTY_USAGE_SCRIPT_VARIABLE and stat.name.ends_with("_modi"):
			var statName = stat.name 
			var statvalue = toolData.get(statName)
			if statvalue == 0.0:
				continue
			if statName.ends_with("Multiplier_modi") and statvalue == 1.0:
				continue 
			
			# pretty messy but i works for now (I hope)
			# The idea is to check the name of the variable to determine how to display it in the description.
			if statName in MODIFIER_DISPLAY_MAP:
				var displayInfo = MODIFIER_DISPLAY_MAP[statName]
				Desc.text += displayInfo.prefix + str(statvalue) + displayInfo.suffix 
			
			Desc.text += "\n"

func showExtraLine(line : String):
	Desc.text += line 
	Desc.text += "\n"