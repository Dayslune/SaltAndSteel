extends Control

#var desc : String
var panel
# Called when the node enters the scene tree for the first time.
var lastPosition 
func _ready() -> void:
	initialize()

func initialize():
	#desc = $Panel/Margin/Stats
	panel = $Panel.duplicate()
	$Panel.queue_free()
	lastPosition = Vector2(0,0)
	#print(panel)
	#createNewPanel("1", panel)

@export var verticalSeparation : float

func createNewPanel(text : String, currentPanel : Panel, textSize = 16.0):
	#initialize()
	var usedPanel = currentPanel.duplicate()
	add_child(usedPanel)

	await usedPanel.ready

	await usedPanel.setup(text,textSize)
	usedPanel.position = lastPosition
	lastPosition.y += usedPanel.size.y + verticalSeparation
	#add_child(usedPanel)
	

func setDesc(toolData : ToolData):
	print("check 1")
	initialize()
	if toolData.toolName:
		createNewPanel("Name: " + str(toolData.toolName) + "\n",panel, 20)

	if toolData is TowerStatModifier:
		setDesc_TowerStatModifier(toolData)
	elif toolData is PlayerStatsChange:
		setDesc_PlayerStatsChange(toolData)
	elif toolData is ApplyEffectCondition:
		setDesc_ApplyEffectCondition(toolData)
	else:
		print("nah")

	print("can continue")

	if toolData.toolDescription:
		print("yes desc")
		showExtraLine(toolData.toolDescription, 14)
	else:
		print("no desc")

func setDesc_TowerStatModifier(toolData : TowerStatModifier):
	#initialize()
	#initialize()
	var desc : String = ""
	#desc = "Name: " + str(toolData.toolName) + "\n"

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
				desc += displayInfo.prefix + str(statvalue) + displayInfo.suffix 
			
			desc += "\n"
		
	createNewPanel(desc,panel)

#v spagetti final boss

func setDesc_PlayerStatsChange(toolData : PlayerStatsChange):
	var desc : String = ""
	if toolData.powerIncreasePerKill != 0:
		desc += "Gain " + str(toolData.powerIncreasePerKill) + " Power when you kill an enemy.\n"
	if toolData.wavePowerRewardIncreaseFlat != 0:
		desc += "Increase wave power reward by " + str(toolData.wavePowerRewardIncreaseFlat) + ".\n"
	if toolData.wavePowerRewardIncreasePercent != 0.0:
		# percent
		var p = toolData.wavePowerRewardIncreasePercent * 100
		desc += "Increase wave power reward by " + str(p) + "% .\n"
	if toolData.wavePowerRewardMultiplier != 1.0:
		desc += "Multiply wave power reward by " + str(toolData.wavePowerRewardMultiplier) + ".\n"
	if toolData.reduceShopCostPercent != 0.0:
		var rp = toolData.reduceShopCostPercent * 100
		desc += "Reduce shop costs by " + str(rp) + "% .\n"
	if desc == "":
		desc = "No player stat changes.\n"
	createNewPanel(desc,panel)


func setDesc_ApplyEffectCondition(toolData : ApplyEffectCondition):
	var desc : String = ""
	if toolData.condition == null:
		desc = "No condition set."
		createNewPanel(desc, panel)
		return

	# describe condition types
	if toolData.condition is EnemyHitConditionData:
		var c : EnemyHitConditionData = toolData.condition
		# describe the status effect applied
		if c.apply != null:
			desc += describe_status_effect(c.apply)
		else:
			desc += "Apply effect."

		# describe the trigger
		if c.hitAmount > 0:
			var byWhat = "a tower"
			if c.hitByTowerType != "":
				byWhat = c.hitByTowerType + " tower"
			desc += " when " + byWhat + " hits it " + str(c.hitAmount) + " times"

	else:
		# generic condition
		desc = "Apply effect when condition met."

	createNewPanel(desc, panel)


func describe_status_effect(se : Effects) -> String:
	if se == null:
		return ""
	print("Tooldes",se.effects)
	for effect in se.effects:
		print("Ok")

		if effect is Slow:
			print("SLOW")
			#var amp_display = ""
			var duration = effect.duration
			var amplifier = effect.amplifier
			return "Slow down an enemy by " + str(amplifier) + "%" + " for " + str(duration) + "s"
		else:
			print("LOL")
			return "effect not found"
	print("NOT SLOW")
	return "error: no effect found"

func decideStatsName():
	pass 

func showExtraLine(line : String, textSize : float = 16.0):
	initialize()
	var desc : String = ""
	desc += line 
	desc += "\n"
	createNewPanel(desc, panel, textSize)
