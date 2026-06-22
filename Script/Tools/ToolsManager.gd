extends Node
class_name ToolsManager

var testTool : ToolData = preload("res://Resources/Tools/Economy/BabelCoin.tres")
@export var loadingTools : Array[ToolData]
var tools : Dictionary = {}
var TowerStatModifierHandler 
var PlayerStatsChangeHandler
var ConditionHandler

func initialize():
	TowerStatModifierHandler = $TowerStatModifier
	PlayerStatsChangeHandler = $PlayerStatsChange

	ConditionHandler = get_tree().get_first_node_in_group("ConditionManager")

	load_tools()

	#addTool(testTool)

	for Tool in tools.values():
		print(Tool.toolName)

#Test 

func _ready():
	initialize()


func load_tools():
	tools.clear() 
	for loadTool in loadingTools:
		tools[loadTool.toolName] = loadTool
	
	print("loaded tools: ", tools)


func addTool(toolData : ToolData):
	Global.toolsList.append(toolData)

	#TO DO: maybe change this in the future. add a apply() function in the resource scripts but current it works for now.

	if toolData is TowerStatModifier:
		TowerStatModifierHandler.addModifier(toolData)
	
	if toolData is PlayerStatsChange:
		PlayerStatsChangeHandler.addModifier(toolData)
	
	if toolData is ApplyEffectCondition:
		ConditionHandler.applyCondition(toolData.condition) # TO DO: kinda rough, would change in the future but now it works well.
	
